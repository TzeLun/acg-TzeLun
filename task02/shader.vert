#version 120

// see the GLSL 1.2 specification:
// https://www.khronos.org/registry/OpenGL/specs/gl/GLSLangSpec.1.20.pdf

#define PI 3.1415926538

varying vec3 normal;  // normal vector pass to the rasterizer
uniform float cam_z_pos;  // camera z position specified by main.cpp

void main()
{
    normal = vec3(gl_Normal); // set normal

    // "gl_Vertex" is the *input* vertex coordinate of triangle.
    // "gl_Position" is the *output* vertex coordinate in the
    // "canonical view volume (i.e.. [-1,+1]^3)" pass to the rasterizer.
    // type of "gl_Vertex" and "gl_Position" are "vec4", which is homogeneious coordinate

    gl_Position = gl_Vertex; // following code do nothing (input == output)

    float x0 = gl_Vertex.x; // x-coord
    float y0 = gl_Vertex.y; // y-coord
    float z0 = gl_Vertex.z; // z-coord
    // modify code below to define transformation from input (x0,y0,z0) to output (x1,y1,z1)
    // such that after transformation, orthogonal z-projection will be fisheye lens effect
    // Specifically, achieve equidistance projection (https://en.wikipedia.org/wiki/Fisheye_lens)
    // the lens is facing -Z direction and lens's position is at (0,0,cam_z_pos)
    // the lens covers all the view direction
    // the "back" direction (i.e., +Z direction) will be projected as the unit circle in XY plane.
    // in GLSL, you can use built-in math function (e.g., sqrt, atan).
    // look at page 56 of https://www.khronos.org/registry/OpenGL/specs/gl/GLSLangSpec.1.20.pdf

    // direction vector in which the lens is facing. Along the optical axis
    vec3 lens_Direction = vec3(0.0f, 0.0f, -1.0f);

    // light ray. Line passing through the lens and the vertex point
    vec3 light_ray = normalize(gl_Vertex.xyz - vec3(0.0f, 0.0f, cam_z_pos));

    // the angle between the ray of light from a vertex point to the optical axis
    float theta = acos(dot(lens_Direction, light_ray) / (length(lens_Direction) * length(light_ray)));

    // radial position of the point from the center (unit circle)
    float r = 1.0f;

    // find the focal length
    float f = r / theta;

    // assign focal length to the x and y coordinate as a simple perspective transformation
    float x1 = f * x0;
    float y1 = f * y0;
    float z1 = z0;

    gl_Position = vec4(x1,y1,z1,1); // homogenious coordinate
}
