/* iPIC3D was originally developed by Stefano Markidis and Giovanni Lapenta. 
 * This release was contributed by Alec Johnson and Ivy Bo Peng.
 * Publications that use results from iPIC3D need to properly cite  
 * 'S. Markidis, G. Lapenta, and Rizwan-uddin. "Multi-scale simulations of 
 * plasma with iPIC3D." Mathematics and Computers in Simulation 80.7 (2010): 1509-1519.'
 *
 *        Copyright 2015 KTH Royal Institute of Technology
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at 
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <string>
#ifndef TIMING_SWMF_H
#define TIMING_SWMF_H

extern "C" {
  // In SWMF/util/TIMING/src/timing.f90
  void timing_start_c(size_t* nameLen, char* name);
  void timing_stop_c(size_t* nameLen, char* name);
}

inline void timing_start(string name){
#ifdef BATSRUS
  size_t nameLen;
  nameLen = name.length();
  char *nameChar=new char[nameLen+1];
  name.copy(nameChar,nameLen);
  timing_start_c(&nameLen, nameChar);
  delete [] nameChar;
#endif
}


inline void timing_stop(string name){
#ifdef BATSRUS
  size_t nameLen;
  nameLen = name.length();
  char *nameChar=new char[nameLen+1];
  name.copy(nameChar,nameLen);
  timing_stop_c(&nameLen, nameChar);
  delete [] nameChar;
#endif
}

#endif
