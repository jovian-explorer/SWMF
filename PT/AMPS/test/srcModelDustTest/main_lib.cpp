//$Id$


#include "pic.h"
#include "constants.h"

#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <string>
#include <list>
#include <math.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>
#include <time.h>
#include <iostream>
#include <iostream>
#include <fstream>
#include <time.h>

#include <sys/time.h>
#include <sys/resource.h>



double Exosphere::SurfaceInteraction::StickingProbability(int spec, double& ReemissionParticleFraction,double Temp) {
  double res=0.0;

  return res;
}

double Exosphere::GetSurfaceTemeprature(double CosSubSolarAngle,double *x_LOCAL_SO_OBJECT) {
  //return the day-side temeprature
  return 100.0;
}

int Exosphere::ColumnIntegral::GetVariableList(char *vlist) {
  return 0;
}

void Exosphere::ColumnIntegral::CoulumnDensityIntegrant(double *res,int resLength,double* x,cTreeNodeAMR<PIC::Mesh::cDataBlockAMR>* node) {

}

void Exosphere::ColumnIntegral::ProcessColumnIntegrationVector(double *res,
							       int resLength) {

}

double Exosphere::OrbitalMotion::GetTAA(SpiceDouble EphemerisTime) {
  return 0.0;
}
