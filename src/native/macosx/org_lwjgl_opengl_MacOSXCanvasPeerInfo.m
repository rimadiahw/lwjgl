/* 
 * Copyright (c) 2002-2008 LWJGL Project
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are 
 * met:
 * 
 * * Redistributions of source code must retain the above copyright 
 *   notice, this list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 *
 * * Neither the name of 'LWJGL' nor the names of 
 *   its contributors may be used to endorse or promote products derived 
 *   from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * $Id$
 *
 * @author elias_naur <elias_naur@users.sourceforge.net>
 * @author Pelle Johnsen
 * @version $Revision$
 */

#import <Cocoa/Cocoa.h>
#include <jni.h>
#include <jawt_md.h>
#include "awt_tools.h"
#include "org_lwjgl_opengl_MacOSXCanvasPeerInfo.h"
#include "context.h"
#include "common_tools.h"

JNIEXPORT void JNICALL Java_org_lwjgl_opengl_MacOSXCanvasPeerInfo_nInitHandle
(JNIEnv *env, jclass clazz, jobject lock_buffer_handle, jobject peer_info_handle) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	MacOSXPeerInfo *peer_info = (MacOSXPeerInfo *)(*env)->GetDirectBufferAddress(env, peer_info_handle);
	AWTSurfaceLock *surface = (AWTSurfaceLock *)(*env)->GetDirectBufferAddress(env, lock_buffer_handle);
	JAWT_MacOSXDrawingSurfaceInfo *macosx_dsi = (JAWT_MacOSXDrawingSurfaceInfo *)surface->dsi->platformInfo;
	
	// check for CALayer support
	if(surface->awt.version & 0x80000000) { //JAWT_MACOSX_USE_CALAYER) {
		
		if (macosx_dsi != NULL) {
			peer_info->glLayer = [GLLayer new];
			peer_info->glLayer->macosx_dsi = macosx_dsi;
			peer_info->glLayer->window_info = peer_info->window_info;
		}
		
		peer_info->isCALayer = true;
		peer_info->isWindowed = true;
		peer_info->parent = nil;
		
		[pool release];
		return;
	}
	
	// no CALayer support, fallback to using legacy method of getting the NSView of an AWT Canvas
	peer_info->parent = macosx_dsi->cocoaViewRef;
	peer_info->isCALayer = false;
	peer_info->isWindowed = true;
	
	[pool release];
}

@implementation GLLayer

- (void) attachLayer {
	self.asynchronous = YES;
	self.needsDisplayOnBoundsChange = YES;
	self.opaque = NO;
	self.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
	
	// get root layer of the AWT Canvas and add self to it
	id <JAWT_SurfaceLayers> surfaceLayers = (id <JAWT_SurfaceLayers>)macosx_dsi;
	surfaceLayers.layer = self;
}

- (void) removeLayer {
	// remove self from root layer
	id <JAWT_SurfaceLayers> surfaceLayers = (id <JAWT_SurfaceLayers>)macosx_dsi;
	surfaceLayers.layer = nil;
}

- (void) blitFrameBuffer {
	
	// get the size of the CALayer/AWT Canvas
	int width = self.bounds.size.width;
	int height = self.bounds.size.height;
	
	if (width != fboWidth || height != fboHeight) {
		
		// store current fbo/renderbuffers for later deletion
		int oldFboID = fboID;
		int oldImageRenderBufferID = imageRenderBufferID;
		int oldDepthRenderBufferID = depthRenderBufferID;
		
		// set the size of the offscreen frame buffer window
		window_info->display_rect = NSMakeRect(0, 0, width, height);
		[window_info->window setFrame:window_info->display_rect display:false];
		
		// create new fbo
		int tempFBO;
		glGenFramebuffersEXT(1, &tempFBO);
		
		// create new render buffers
		glGenRenderbuffersEXT(1, &imageRenderBufferID);
		glGenRenderbuffersEXT(1, &depthRenderBufferID);
		
		// switch to new fbo to attach render buffers
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, tempFBO);
		
		// initialize and attach image render buffer
		glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, imageRenderBufferID);
		glRenderbufferStorageEXT(GL_RENDERBUFFER_EXT, GL_RGB, width, height);
		glFramebufferRenderbufferEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_RENDERBUFFER_EXT, imageRenderBufferID);
		
		// initialize and attach depth render buffer
		glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, depthRenderBufferID);
		glRenderbufferStorageEXT(GL_RENDERBUFFER_EXT, GL_DEPTH_COMPONENT24, width, height);
		glFramebufferRenderbufferEXT(GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, depthRenderBufferID);
		
		// set new fbo and its sizes
		fboID = tempFBO;
		fboWidth = width;
		fboHeight = height;
		
		// clean up the old fbo and renderBuffers
		glDeleteFramebuffersEXT(1, &oldFboID);
		glDeleteRenderbuffersEXT(1, &oldImageRenderBufferID);
		glDeleteRenderbuffersEXT(1, &oldDepthRenderBufferID);
	}
	else {
		glBindFramebufferEXT(GL_READ_FRAMEBUFFER_EXT, 0);
		glBindFramebufferEXT(GL_DRAW_FRAMEBUFFER_EXT, fboID);
		
		glBlitFramebufferEXT(0, 0, width, height,
							 0, 0, width, height,
							 GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT,
							 GL_NEAREST);
	}
	
	// restore default framebuffer
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
}

-(void)drawInCGLContext:(CGLContextObj)glContext
						pixelFormat:(CGLPixelFormatObj)pixelFormat
						forLayerTime:(CFTimeInterval)timeInterval
						displayTime:(const CVTimeStamp *)timeStamp {
	
	// set the current context
	CGLSetCurrentContext(glContext);
	
	if (fboID == 0) {
		// clear garbage background before lwjgl fbo is set
		glClearColor(0.0, 0.0, 0.0, 1.0);
		glClear(GL_COLOR_BUFFER_BIT);
	}
	
	// get the size of the CALayer
	int width = fboWidth;
	int height = fboHeight;
	
	GLint originalReadFBO;
	
	// get and save the current fbo values
	glGetIntegerv(GL_READ_FRAMEBUFFER_BINDING_EXT, &originalReadFBO);
	
	// read the LWJGL FBO and blit it into this CALayers FBO
	glBindFramebufferEXT(GL_READ_FRAMEBUFFER_EXT, fboID);
	glBlitFramebufferEXT(0, 0, width, height,
						 0, 0, width, height,
						 GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT,
						 GL_NEAREST);
	
	// restore original fbo read value
	glBindFramebufferEXT(GL_READ_FRAMEBUFFER_EXT, originalReadFBO);
	
	// call super to finalize the drawing - by default all it does is call glFlush()
	[super drawInCGLContext:glContext pixelFormat:pixelFormat forLayerTime:timeInterval displayTime:timeStamp];
}

-(BOOL)canDrawInCGLContext:(CGLContextObj)glContext
							pixelFormat:(CGLPixelFormatObj)pixelFormat
							forLayerTime:(CFTimeInterval)timeInterval
							displayTime:(const CVTimeStamp *)timeStamp {
	return YES;
}

- (CGLContextObj)copyCGLContextForPixelFormat:(CGLPixelFormatObj)pixelFormat {
	CGLCreateContext(pixelFormat, [window_info->context CGLContextObj], &contextObject);
	return contextObject;
}

- (void)releaseCGLContext:(CGLContextObj)glContext {
	CGLDestroyContext(contextObject);
}

- (CGLPixelFormatObj)copyCGLPixelFormatForDisplayMask:(uint32_t)mask {
	return CGLGetPixelFormat([window_info->context CGLContextObj]);
}

- (void)releaseCGLPixelFormat:(CGLPixelFormatObj)pixelFormat {
	
}

@end