/* DO NOT EDIT THIS FILE - it is machine generated */
#include <jni.h>
/* Header for class org_lwjgl_opengl_Pbuffer */

#ifndef _Included_org_lwjgl_opengl_Pbuffer
#define _Included_org_lwjgl_opengl_Pbuffer
#ifdef __cplusplus
extern "C" {
#endif
#undef org_lwjgl_opengl_Pbuffer_PBUFFER_SUPPORTED
#define org_lwjgl_opengl_Pbuffer_PBUFFER_SUPPORTED 1L
#undef org_lwjgl_opengl_Pbuffer_RENDER_TEXTURE_SUPPORTED
#define org_lwjgl_opengl_Pbuffer_RENDER_TEXTURE_SUPPORTED 2L
#undef org_lwjgl_opengl_Pbuffer_RENDER_TEXTURE_RECTANGLE_SUPPORTED
#define org_lwjgl_opengl_Pbuffer_RENDER_TEXTURE_RECTANGLE_SUPPORTED 4L
#undef org_lwjgl_opengl_Pbuffer_RENDER_DEPTH_TEXTURE_SUPPORTED
#define org_lwjgl_opengl_Pbuffer_RENDER_DEPTH_TEXTURE_SUPPORTED 8L
#undef org_lwjgl_opengl_Pbuffer_MIPMAP_LEVEL
#define org_lwjgl_opengl_Pbuffer_MIPMAP_LEVEL 8315L
#undef org_lwjgl_opengl_Pbuffer_CUBE_MAP_FACE
#define org_lwjgl_opengl_Pbuffer_CUBE_MAP_FACE 8316L
#undef org_lwjgl_opengl_Pbuffer_TEXTURE_CUBE_MAP_POSITIVE_X
#define org_lwjgl_opengl_Pbuffer_TEXTURE_CUBE_MAP_POSITIVE_X 8317L
#undef org_lwjgl_opengl_Pbuffer_TEXTURE_CUBE_MAP_NEGATIVE_X
#define org_lwjgl_opengl_Pbuffer_TEXTURE_CUBE_MAP_NEGATIVE_X 8318L
#undef org_lwjgl_opengl_Pbuffer_TEXTURE_CUBE_MAP_POSITIVE_Y
#define org_lwjgl_opengl_Pbuffer_TEXTURE_CUBE_MAP_POSITIVE_Y 8319L
#undef org_lwjgl_opengl_Pbuffer_TEXTURE_CUBE_MAP_NEGATIVE_Y
#define org_lwjgl_opengl_Pbuffer_TEXTURE_CUBE_MAP_NEGATIVE_Y 8320L
#undef org_lwjgl_opengl_Pbuffer_TEXTURE_CUBE_MAP_POSITIVE_Z
#define org_lwjgl_opengl_Pbuffer_TEXTURE_CUBE_MAP_POSITIVE_Z 8321L
#undef org_lwjgl_opengl_Pbuffer_TEXTURE_CUBE_MAP_NEGATIVE_Z
#define org_lwjgl_opengl_Pbuffer_TEXTURE_CUBE_MAP_NEGATIVE_Z 8322L
#undef org_lwjgl_opengl_Pbuffer_FRONT_LEFT_BUFFER
#define org_lwjgl_opengl_Pbuffer_FRONT_LEFT_BUFFER 8323L
#undef org_lwjgl_opengl_Pbuffer_FRONT_RIGHT_BUFFER
#define org_lwjgl_opengl_Pbuffer_FRONT_RIGHT_BUFFER 8324L
#undef org_lwjgl_opengl_Pbuffer_BACK_LEFT_BUFFER
#define org_lwjgl_opengl_Pbuffer_BACK_LEFT_BUFFER 8325L
#undef org_lwjgl_opengl_Pbuffer_BACK_RIGHT_BUFFER
#define org_lwjgl_opengl_Pbuffer_BACK_RIGHT_BUFFER 8326L
#undef org_lwjgl_opengl_Pbuffer_DEPTH_BUFFER
#define org_lwjgl_opengl_Pbuffer_DEPTH_BUFFER 8359L
/* Inaccessible static: currentBuffer */
/*
 * Class:     org_lwjgl_opengl_Pbuffer
 * Method:    nIsBufferLost
 * Signature: (I)Z
 */
JNIEXPORT jboolean JNICALL Java_org_lwjgl_opengl_Pbuffer_nIsBufferLost
  (JNIEnv *, jclass, jint);

/*
 * Class:     org_lwjgl_opengl_Pbuffer
 * Method:    nMakeCurrent
 * Signature: (I)V
 */
JNIEXPORT void JNICALL Java_org_lwjgl_opengl_Pbuffer_nMakeCurrent
  (JNIEnv *, jclass, jint);

/*
 * Class:     org_lwjgl_opengl_Pbuffer
 * Method:    getPbufferCaps
 * Signature: ()I
 */
JNIEXPORT jint JNICALL Java_org_lwjgl_opengl_Pbuffer_getPbufferCaps
  (JNIEnv *, jclass);

/*
 * Class:     org_lwjgl_opengl_Pbuffer
 * Method:    nCreate
 * Signature: (IILorg/lwjgl/opengl/PixelFormat;Ljava/nio/IntBuffer;Ljava/nio/IntBuffer;)I
 */
JNIEXPORT jint JNICALL Java_org_lwjgl_opengl_Pbuffer_nCreate
  (JNIEnv *, jclass, jint, jint, jobject, jobject, jobject);

/*
 * Class:     org_lwjgl_opengl_Pbuffer
 * Method:    nDestroy
 * Signature: (I)V
 */
JNIEXPORT void JNICALL Java_org_lwjgl_opengl_Pbuffer_nDestroy
  (JNIEnv *, jclass, jint);

/*
 * Class:     org_lwjgl_opengl_Pbuffer
 * Method:    nSetAttrib
 * Signature: (III)V
 */
JNIEXPORT void JNICALL Java_org_lwjgl_opengl_Pbuffer_nSetAttrib
  (JNIEnv *, jclass, jint, jint, jint);

/*
 * Class:     org_lwjgl_opengl_Pbuffer
 * Method:    nBindTexImage
 * Signature: (II)V
 */
JNIEXPORT void JNICALL Java_org_lwjgl_opengl_Pbuffer_nBindTexImage
  (JNIEnv *, jclass, jint, jint);

/*
 * Class:     org_lwjgl_opengl_Pbuffer
 * Method:    nReleaseTexImage
 * Signature: (II)V
 */
JNIEXPORT void JNICALL Java_org_lwjgl_opengl_Pbuffer_nReleaseTexImage
  (JNIEnv *, jclass, jint, jint);

#ifdef __cplusplus
}
#endif
#endif
