#ifndef GEOMFIG_H
#define GEOMFIG_H

#include <allegro.h>
#include <stdlib.h>
#include <cmath>
#include <algorithm>
#include <list>
#include <vector>

using namespace std;

struct vec {
        vec(float x, float y) {
                this->x = x; this->y = y;
        }
        vec() {
                x=0;y=0;
        }
        float x,y,le;
        inline float l() {
                return sqrt(x*x+y*y);
        }
        inline vec rotate() {
                return {y,-x};
        }
        inline vec operator+(vec vec1) {
                return {x+vec1.x, y+vec1.y};
        }
        inline vec operator-(vec vec1) {
                return {x-vec1.x, y-vec1.y};
        }
        inline vec operator*(float f) {
                return {x*f, y*f};
        }
        inline vec operator/(float f) {
                return {x/f, y/f};
        }
        inline void rotate(float angle) {
                float x1,y1;
                x1 = x*cos(angle) - y*sin(angle);
                y1 = x*sin(angle) + y*cos(angle);
                x = x1;
                y = y1;
        }
};

template<class T> struct ringvec {
        vector<T> _vector;

        inline void push_back(T in) {
                _vector.push_back(in);
        }
        inline T operator[](int i) {
                int s = _vector.size();
                if(i >= s) {
                        i %= s;
                        i--;
                }
                if(i < 0) {
                        i = -i;
                        i %= s;
                        i = s -i;
                }
                return _vector[i];
        }
        inline int size() {
                return _vector.size();
        }
};
struct _line {
        vec a,b;
};

struct geomfig {
        vector<geomfig> childs;
        ringvec<vec*> prototype;
        ringvec<vec*> outline;
        vec pivot;
        float angle;
        float scale;

        void apply() {
                outline = ringvec<vec*>();
                for(int i = 0; i < prototype.size(); i++)
                {
                        vec vtmp = vec(*prototype[i]);
                        vtmp.rotate(angle);
                        vtmp = vtmp * scale;
                        vtmp = vtmp + pivot;
                        outline.push_back(new vec(vtmp));
                }
        }
};

float lambda1 = 0;
float lambda2 = 0;
bool collide(vec& va, vec& vb, vec& vc, vec& vd) {
        vec vab(vb.x-va.x,vb.y-va.y);
        vec vcd(vd.x-vc.x,vd.y-vc.y);
        lambda1 = -(vab.x*vc.y+(va.x-vc.x)*vab.y-vab.x*va.y)/(vab.x*vcd.y-vcd.x*vab.y);
        lambda2 = -(vcd.x*vc.y-vcd.y*vc.x+va.x*vcd.y-va.y*vcd.x)/(vab.x*vcd.y-vab.y*vcd.x);

        return lambda1 >= 0 && lambda1 <= 1 && lambda2 >= 0 && lambda2 <= 1;
}

#endif // GEOMFIG_H
