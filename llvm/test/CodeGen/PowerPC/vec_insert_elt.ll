; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names \
; RUN:   -ppc-vsr-nums-as-vr < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names \
; RUN:   -ppc-vsr-nums-as-vr < %s | FileCheck %s --check-prefix=CHECK-BE
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:   -mcpu=pwr9 -ppc-asm-full-reg-names \
; RUN:   -ppc-vsr-nums-as-vr < %s | FileCheck %s --check-prefix=CHECK-P9

; Byte indexed

define <16 x i8> @testByte(<16 x i8> %a, i64 %b, i64 %idx) {
; CHECK-LABEL: testByte:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vinsbrx v2, r6, r5
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testByte:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    vinsblx v2, r6, r5
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testByte:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    addi r4, r1, -16
; CHECK-P9-NEXT:    clrldi r3, r6, 60
; CHECK-P9-NEXT:    stxv v2, -16(r1)
; CHECK-P9-NEXT:    stbx r5, r4, r3
; CHECK-P9-NEXT:    lxv v2, -16(r1)
; CHECK-P9-NEXT:    blr
entry:
  %conv = trunc i64 %b to i8
  %vecins = insertelement <16 x i8> %a, i8 %conv, i64 %idx
  ret <16 x i8> %vecins
}

; Halfword indexed

define <8 x i16> @testHalf(<8 x i16> %a, i64 %b, i64 %idx) {
; CHECK-LABEL: testHalf:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    slwi r3, r6, 1
; CHECK-NEXT:    vinshrx v2, r3, r5
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testHalf:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    slwi r3, r6, 1
; CHECK-BE-NEXT:    vinshlx v2, r3, r5
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testHalf:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    addi r4, r1, -16
; CHECK-P9-NEXT:    rlwinm r3, r6, 1, 28, 30
; CHECK-P9-NEXT:    stxv v2, -16(r1)
; CHECK-P9-NEXT:    sthx r5, r4, r3
; CHECK-P9-NEXT:    lxv v2, -16(r1)
; CHECK-P9-NEXT:    blr
entry:
  %conv = trunc i64 %b to i16
  %vecins = insertelement <8 x i16> %a, i16 %conv, i64 %idx
  ret <8 x i16> %vecins
}

; Word indexed

define <4 x i32> @testWord(<4 x i32> %a, i64 %b, i64 %idx) {
; CHECK-LABEL: testWord:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    slwi r3, r6, 2
; CHECK-NEXT:    vinswrx v2, r3, r5
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testWord:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    slwi r3, r6, 2
; CHECK-BE-NEXT:    vinswlx v2, r3, r5
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testWord:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    addi r4, r1, -16
; CHECK-P9-NEXT:    rlwinm r3, r6, 2, 28, 29
; CHECK-P9-NEXT:    stxv v2, -16(r1)
; CHECK-P9-NEXT:    stwx r5, r4, r3
; CHECK-P9-NEXT:    lxv v2, -16(r1)
; CHECK-P9-NEXT:    blr
entry:
  %conv = trunc i64 %b to i32
  %vecins = insertelement <4 x i32> %a, i32 %conv, i64 %idx
  ret <4 x i32> %vecins
}

; Word immediate

define <4 x i32> @testWordImm(<4 x i32> %a, i64 %b) {
; CHECK-LABEL: testWordImm:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vinsw v2, r5, 8
; CHECK-NEXT:    vinsw v2, r5, 0
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testWordImm:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    vinsw v2, r5, 4
; CHECK-BE-NEXT:    vinsw v2, r5, 12
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testWordImm:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    mtfprwz f0, r5
; CHECK-P9-NEXT:    xxinsertw v2, vs0, 4
; CHECK-P9-NEXT:    xxinsertw v2, vs0, 12
; CHECK-P9-NEXT:    blr
entry:
  %conv = trunc i64 %b to i32
  %vecins = insertelement <4 x i32> %a, i32 %conv, i32 1
  %vecins2 = insertelement <4 x i32> %vecins, i32 %conv, i32 3
  ret <4 x i32> %vecins2
}

; Doubleword indexed

define <2 x i64> @testDoubleword(<2 x i64> %a, i64 %b, i64 %idx) {
; CHECK-LABEL: testDoubleword:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    rlwinm r3, r6, 3, 0, 28
; CHECK-NEXT:    vinsdrx v2, r3, r5
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testDoubleword:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    rlwinm r3, r6, 3, 0, 28
; CHECK-BE-NEXT:    vinsdlx v2, r3, r5
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testDoubleword:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    addi r4, r1, -16
; CHECK-P9-NEXT:    rlwinm r3, r6, 3, 28, 28
; CHECK-P9-NEXT:    stxv v2, -16(r1)
; CHECK-P9-NEXT:    stdx r5, r4, r3
; CHECK-P9-NEXT:    lxv v2, -16(r1)
; CHECK-P9-NEXT:    blr
entry:
  %vecins = insertelement <2 x i64> %a, i64 %b, i64 %idx
  ret <2 x i64> %vecins
}

; Doubleword immediate

define <2 x i64> @testDoublewordImm(<2 x i64> %a, i64 %b) {
; CHECK-LABEL: testDoublewordImm:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vinsd v2, r5, 0
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testDoublewordImm:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    vinsd v2, r5, 8
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testDoublewordImm:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    mtfprd f0, r5
; CHECK-P9-NEXT:    xxmrghd v2, v2, vs0
; CHECK-P9-NEXT:    blr
entry:
  %vecins = insertelement <2 x i64> %a, i64 %b, i32 1
  ret <2 x i64> %vecins
}

define <2 x i64> @testDoublewordImm2(<2 x i64> %a, i64 %b) {
; CHECK-LABEL: testDoublewordImm2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vinsd v2, r5, 8
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testDoublewordImm2:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    vinsd v2, r5, 0
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testDoublewordImm2:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    mtfprd f0, r5
; CHECK-P9-NEXT:    xxpermdi v2, vs0, v2, 1
; CHECK-P9-NEXT:    blr
entry:
  %vecins = insertelement <2 x i64> %a, i64 %b, i32 0
  ret <2 x i64> %vecins
}

; Float indexed

define <4 x float> @testFloat1(<4 x float> %a, float %b, i32 zeroext %idx1) {
; CHECK-LABEL: testFloat1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xscvdpspn v3, f1
; CHECK-NEXT:    extsw r3, r6
; CHECK-NEXT:    slwi r3, r3, 2
; CHECK-NEXT:    vinswvrx v2, r3, v3
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testFloat1:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xscvdpspn v3, f1
; CHECK-BE-NEXT:    extsw r3, r6
; CHECK-BE-NEXT:    slwi r3, r3, 2
; CHECK-BE-NEXT:    vinswvlx v2, r3, v3
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testFloat1:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    addi r4, r1, -16
; CHECK-P9-NEXT:    rlwinm r3, r6, 2, 28, 29
; CHECK-P9-NEXT:    stxv v2, -16(r1)
; CHECK-P9-NEXT:    stfsx f1, r4, r3
; CHECK-P9-NEXT:    lxv v2, -16(r1)
; CHECK-P9-NEXT:    blr
entry:
  %vecins = insertelement <4 x float> %a, float %b, i32 %idx1
  ret <4 x float> %vecins
}

define <4 x float> @testFloat2(<4 x float> %a, i8* %b, i32 zeroext %idx1, i32 zeroext %idx2) {
; CHECK-LABEL: testFloat2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lwz r3, 0(r5)
; CHECK-NEXT:    extsw r4, r6
; CHECK-NEXT:    slwi r4, r4, 2
; CHECK-NEXT:    vinswrx v2, r4, r3
; CHECK-NEXT:    lwz r3, 1(r5)
; CHECK-NEXT:    extsw r4, r7
; CHECK-NEXT:    slwi r4, r4, 2
; CHECK-NEXT:    vinswrx v2, r4, r3
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testFloat2:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lwz r3, 0(r5)
; CHECK-BE-NEXT:    extsw r4, r6
; CHECK-BE-NEXT:    slwi r4, r4, 2
; CHECK-BE-NEXT:    vinswlx v2, r4, r3
; CHECK-BE-NEXT:    lwz r3, 1(r5)
; CHECK-BE-NEXT:    extsw r4, r7
; CHECK-BE-NEXT:    slwi r4, r4, 2
; CHECK-BE-NEXT:    vinswlx v2, r4, r3
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testFloat2:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lwz r3, 0(r5)
; CHECK-P9-NEXT:    rlwinm r4, r6, 2, 28, 29
; CHECK-P9-NEXT:    addi r6, r1, -16
; CHECK-P9-NEXT:    stxv v2, -16(r1)
; CHECK-P9-NEXT:    stwx r3, r6, r4
; CHECK-P9-NEXT:    rlwinm r4, r7, 2, 28, 29
; CHECK-P9-NEXT:    lxv vs0, -16(r1)
; CHECK-P9-NEXT:    lwz r3, 1(r5)
; CHECK-P9-NEXT:    addi r5, r1, -32
; CHECK-P9-NEXT:    stxv vs0, -32(r1)
; CHECK-P9-NEXT:    stwx r3, r5, r4
; CHECK-P9-NEXT:    lxv v2, -32(r1)
; CHECK-P9-NEXT:    blr
entry:
  %0 = bitcast i8* %b to float*
  %add.ptr1 = getelementptr inbounds i8, i8* %b, i64 1
  %1 = bitcast i8* %add.ptr1 to float*
  %2 = load float, float* %0, align 4
  %vecins = insertelement <4 x float> %a, float %2, i32 %idx1
  %3 = load float, float* %1, align 4
  %vecins2 = insertelement <4 x float> %vecins, float %3, i32 %idx2
  ret <4 x float> %vecins2
}

define <4 x float> @testFloat3(<4 x float> %a, i8* %b, i32 zeroext %idx1, i32 zeroext %idx2) {
; CHECK-LABEL: testFloat3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    plwz r3, 65536(r5), 0
; CHECK-NEXT:    extsw r4, r6
; CHECK-NEXT:    slwi r4, r4, 2
; CHECK-NEXT:    vinswrx v2, r4, r3
; CHECK-NEXT:    li r3, 1
; CHECK-NEXT:    extsw r4, r7
; CHECK-NEXT:    rldic r3, r3, 36, 27
; CHECK-NEXT:    slwi r4, r4, 2
; CHECK-NEXT:    lwzx r3, r5, r3
; CHECK-NEXT:    vinswrx v2, r4, r3
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testFloat3:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    plwz r3, 65536(r5), 0
; CHECK-BE-NEXT:    extsw r4, r6
; CHECK-BE-NEXT:    slwi r4, r4, 2
; CHECK-BE-NEXT:    vinswlx v2, r4, r3
; CHECK-BE-NEXT:    li r3, 1
; CHECK-BE-NEXT:    extsw r4, r7
; CHECK-BE-NEXT:    rldic r3, r3, 36, 27
; CHECK-BE-NEXT:    slwi r4, r4, 2
; CHECK-BE-NEXT:    lwzx r3, r5, r3
; CHECK-BE-NEXT:    vinswlx v2, r4, r3
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testFloat3:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lis r3, 1
; CHECK-P9-NEXT:    rlwinm r4, r6, 2, 28, 29
; CHECK-P9-NEXT:    addi r6, r1, -16
; CHECK-P9-NEXT:    lwzx r3, r5, r3
; CHECK-P9-NEXT:    stxv v2, -16(r1)
; CHECK-P9-NEXT:    stwx r3, r6, r4
; CHECK-P9-NEXT:    li r3, 1
; CHECK-P9-NEXT:    rlwinm r4, r7, 2, 28, 29
; CHECK-P9-NEXT:    lxv vs0, -16(r1)
; CHECK-P9-NEXT:    rldic r3, r3, 36, 27
; CHECK-P9-NEXT:    lwzx r3, r5, r3
; CHECK-P9-NEXT:    addi r5, r1, -32
; CHECK-P9-NEXT:    stxv vs0, -32(r1)
; CHECK-P9-NEXT:    stwx r3, r5, r4
; CHECK-P9-NEXT:    lxv v2, -32(r1)
; CHECK-P9-NEXT:    blr
entry:
  %add.ptr = getelementptr inbounds i8, i8* %b, i64 65536
  %0 = bitcast i8* %add.ptr to float*
  %add.ptr1 = getelementptr inbounds i8, i8* %b, i64 68719476736
  %1 = bitcast i8* %add.ptr1 to float*
  %2 = load float, float* %0, align 4
  %vecins = insertelement <4 x float> %a, float %2, i32 %idx1
  %3 = load float, float* %1, align 4
  %vecins2 = insertelement <4 x float> %vecins, float %3, i32 %idx2
  ret <4 x float> %vecins2
}

; Float immediate

define <4 x float> @testFloatImm1(<4 x float> %a, float %b) {
; CHECK-LABEL: testFloatImm1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xscvdpspn vs0, f1
; CHECK-NEXT:    xxinsertw v2, vs0, 12
; CHECK-NEXT:    xxinsertw v2, vs0, 4
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testFloatImm1:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xscvdpspn vs0, f1
; CHECK-BE-NEXT:    xxinsertw v2, vs0, 0
; CHECK-BE-NEXT:    xxinsertw v2, vs0, 8
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testFloatImm1:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    xscvdpspn vs0, f1
; CHECK-P9-NEXT:    xxinsertw v2, vs0, 0
; CHECK-P9-NEXT:    xxinsertw v2, vs0, 8
; CHECK-P9-NEXT:    blr
entry:
  %vecins = insertelement <4 x float> %a, float %b, i32 0
  %vecins1 = insertelement <4 x float> %vecins, float %b, i32 2
  ret <4 x float> %vecins1
}

define <4 x float> @testFloatImm2(<4 x float> %a, i32* %b) {
; CHECK-LABEL: testFloatImm2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lwz r3, 0(r5)
; CHECK-NEXT:    vinsw v2, r3, 12
; CHECK-NEXT:    lwz r3, 4(r5)
; CHECK-NEXT:    vinsw v2, r3, 4
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testFloatImm2:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lwz r3, 0(r5)
; CHECK-BE-NEXT:    vinsw v2, r3, 0
; CHECK-BE-NEXT:    lwz r3, 4(r5)
; CHECK-BE-NEXT:    vinsw v2, r3, 8
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testFloatImm2:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lwz r3, 0(r5)
; CHECK-P9-NEXT:    mtfprwz f0, r3
; CHECK-P9-NEXT:    lwz r3, 4(r5)
; CHECK-P9-NEXT:    xxinsertw v2, vs0, 0
; CHECK-P9-NEXT:    mtfprwz f0, r3
; CHECK-P9-NEXT:    xxinsertw v2, vs0, 8
; CHECK-P9-NEXT:    blr
entry:
  %0 = bitcast i32* %b to float*
  %add.ptr1 = getelementptr inbounds i32, i32* %b, i64 1
  %1 = bitcast i32* %add.ptr1 to float*
  %2 = load float, float* %0, align 4
  %vecins = insertelement <4 x float> %a, float %2, i32 0
  %3 = load float, float* %1, align 4
  %vecins2 = insertelement <4 x float> %vecins, float %3, i32 2
  ret <4 x float> %vecins2
}

define <4 x float> @testFloatImm3(<4 x float> %a, i32* %b) {
; CHECK-LABEL: testFloatImm3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    plwz r3, 262144(r5), 0
; CHECK-NEXT:    vinsw v2, r3, 12
; CHECK-NEXT:    li r3, 1
; CHECK-NEXT:    rldic r3, r3, 38, 25
; CHECK-NEXT:    lwzx r3, r5, r3
; CHECK-NEXT:    vinsw v2, r3, 4
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testFloatImm3:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    plwz r3, 262144(r5), 0
; CHECK-BE-NEXT:    vinsw v2, r3, 0
; CHECK-BE-NEXT:    li r3, 1
; CHECK-BE-NEXT:    rldic r3, r3, 38, 25
; CHECK-BE-NEXT:    lwzx r3, r5, r3
; CHECK-BE-NEXT:    vinsw v2, r3, 8
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testFloatImm3:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lis r3, 4
; CHECK-P9-NEXT:    lwzx r3, r5, r3
; CHECK-P9-NEXT:    mtfprwz f0, r3
; CHECK-P9-NEXT:    li r3, 1
; CHECK-P9-NEXT:    rldic r3, r3, 38, 25
; CHECK-P9-NEXT:    xxinsertw v2, vs0, 0
; CHECK-P9-NEXT:    lwzx r3, r5, r3
; CHECK-P9-NEXT:    mtfprwz f0, r3
; CHECK-P9-NEXT:    xxinsertw v2, vs0, 8
; CHECK-P9-NEXT:    blr
entry:
  %add.ptr = getelementptr inbounds i32, i32* %b, i64 65536
  %0 = bitcast i32* %add.ptr to float*
  %add.ptr1 = getelementptr inbounds i32, i32* %b, i64 68719476736
  %1 = bitcast i32* %add.ptr1 to float*
  %2 = load float, float* %0, align 4
  %vecins = insertelement <4 x float> %a, float %2, i32 0
  %3 = load float, float* %1, align 4
  %vecins2 = insertelement <4 x float> %vecins, float %3, i32 2
  ret <4 x float> %vecins2
}

; Double indexed

define <2 x double> @testDouble1(<2 x double> %a, double %b, i32 zeroext %idx1) {
; CHECK-LABEL: testDouble1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    extsw r4, r6
; CHECK-NEXT:    mffprd r3, f1
; CHECK-NEXT:    rlwinm r4, r4, 3, 0, 28
; CHECK-NEXT:    vinsdrx v2, r4, r3
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testDouble1:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    extsw r4, r6
; CHECK-BE-NEXT:    mffprd r3, f1
; CHECK-BE-NEXT:    rlwinm r4, r4, 3, 0, 28
; CHECK-BE-NEXT:    vinsdlx v2, r4, r3
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testDouble1:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    addi r4, r1, -16
; CHECK-P9-NEXT:    rlwinm r3, r6, 3, 28, 28
; CHECK-P9-NEXT:    stxv v2, -16(r1)
; CHECK-P9-NEXT:    stfdx f1, r4, r3
; CHECK-P9-NEXT:    lxv v2, -16(r1)
; CHECK-P9-NEXT:    blr
entry:
  %vecins = insertelement <2 x double> %a, double %b, i32 %idx1
  ret <2 x double> %vecins
}

define <2 x double> @testDouble2(<2 x double> %a, i8* %b, i32 zeroext %idx1, i32 zeroext %idx2) {
; CHECK-LABEL: testDouble2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ld r3, 0(r5)
; CHECK-NEXT:    extsw r4, r6
; CHECK-NEXT:    rlwinm r4, r4, 3, 0, 28
; CHECK-NEXT:    vinsdrx v2, r4, r3
; CHECK-NEXT:    pld r3, 1(r5), 0
; CHECK-NEXT:    extsw r4, r7
; CHECK-NEXT:    rlwinm r4, r4, 3, 0, 28
; CHECK-NEXT:    vinsdrx v2, r4, r3
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testDouble2:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    ld r3, 0(r5)
; CHECK-BE-NEXT:    extsw r4, r6
; CHECK-BE-NEXT:    rlwinm r4, r4, 3, 0, 28
; CHECK-BE-NEXT:    vinsdlx v2, r4, r3
; CHECK-BE-NEXT:    pld r3, 1(r5), 0
; CHECK-BE-NEXT:    extsw r4, r7
; CHECK-BE-NEXT:    rlwinm r4, r4, 3, 0, 28
; CHECK-BE-NEXT:    vinsdlx v2, r4, r3
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testDouble2:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    ld r3, 0(r5)
; CHECK-P9-NEXT:    rlwinm r4, r6, 3, 28, 28
; CHECK-P9-NEXT:    addi r6, r1, -32
; CHECK-P9-NEXT:    stxv v2, -32(r1)
; CHECK-P9-NEXT:    stdx r3, r6, r4
; CHECK-P9-NEXT:    li r3, 1
; CHECK-P9-NEXT:    rlwinm r4, r7, 3, 28, 28
; CHECK-P9-NEXT:    lxv vs0, -32(r1)
; CHECK-P9-NEXT:    ldx r3, r5, r3
; CHECK-P9-NEXT:    addi r5, r1, -16
; CHECK-P9-NEXT:    stxv vs0, -16(r1)
; CHECK-P9-NEXT:    stdx r3, r5, r4
; CHECK-P9-NEXT:    lxv v2, -16(r1)
; CHECK-P9-NEXT:    blr
entry:
  %0 = bitcast i8* %b to double*
  %add.ptr1 = getelementptr inbounds i8, i8* %b, i64 1
  %1 = bitcast i8* %add.ptr1 to double*
  %2 = load double, double* %0, align 8
  %vecins = insertelement <2 x double> %a, double %2, i32 %idx1
  %3 = load double, double* %1, align 8
  %vecins2 = insertelement <2 x double> %vecins, double %3, i32 %idx2
  ret <2 x double> %vecins2
}

define <2 x double> @testDouble3(<2 x double> %a, i8* %b, i32 zeroext %idx1, i32 zeroext %idx2) {
; CHECK-LABEL: testDouble3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pld r3, 65536(r5), 0
; CHECK-NEXT:    extsw r4, r6
; CHECK-NEXT:    rlwinm r4, r4, 3, 0, 28
; CHECK-NEXT:    vinsdrx v2, r4, r3
; CHECK-NEXT:    li r3, 1
; CHECK-NEXT:    extsw r4, r7
; CHECK-NEXT:    rldic r3, r3, 36, 27
; CHECK-NEXT:    rlwinm r4, r4, 3, 0, 28
; CHECK-NEXT:    ldx r3, r5, r3
; CHECK-NEXT:    vinsdrx v2, r4, r3
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testDouble3:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    pld r3, 65536(r5), 0
; CHECK-BE-NEXT:    extsw r4, r6
; CHECK-BE-NEXT:    rlwinm r4, r4, 3, 0, 28
; CHECK-BE-NEXT:    vinsdlx v2, r4, r3
; CHECK-BE-NEXT:    li r3, 1
; CHECK-BE-NEXT:    extsw r4, r7
; CHECK-BE-NEXT:    rldic r3, r3, 36, 27
; CHECK-BE-NEXT:    rlwinm r4, r4, 3, 0, 28
; CHECK-BE-NEXT:    ldx r3, r5, r3
; CHECK-BE-NEXT:    vinsdlx v2, r4, r3
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testDouble3:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lis r3, 1
; CHECK-P9-NEXT:    rlwinm r4, r6, 3, 28, 28
; CHECK-P9-NEXT:    addi r6, r1, -32
; CHECK-P9-NEXT:    ldx r3, r5, r3
; CHECK-P9-NEXT:    stxv v2, -32(r1)
; CHECK-P9-NEXT:    stdx r3, r6, r4
; CHECK-P9-NEXT:    li r3, 1
; CHECK-P9-NEXT:    rlwinm r4, r7, 3, 28, 28
; CHECK-P9-NEXT:    lxv vs0, -32(r1)
; CHECK-P9-NEXT:    rldic r3, r3, 36, 27
; CHECK-P9-NEXT:    ldx r3, r5, r3
; CHECK-P9-NEXT:    addi r5, r1, -16
; CHECK-P9-NEXT:    stxv vs0, -16(r1)
; CHECK-P9-NEXT:    stdx r3, r5, r4
; CHECK-P9-NEXT:    lxv v2, -16(r1)
; CHECK-P9-NEXT:    blr
entry:
  %add.ptr = getelementptr inbounds i8, i8* %b, i64 65536
  %0 = bitcast i8* %add.ptr to double*
  %add.ptr1 = getelementptr inbounds i8, i8* %b, i64 68719476736
  %1 = bitcast i8* %add.ptr1 to double*
  %2 = load double, double* %0, align 8
  %vecins = insertelement <2 x double> %a, double %2, i32 %idx1
  %3 = load double, double* %1, align 8
  %vecins2 = insertelement <2 x double> %vecins, double %3, i32 %idx2
  ret <2 x double> %vecins2
}

; Double immediate

define <2 x double> @testDoubleImm1(<2 x double> %a, double %b) {
; CHECK-LABEL: testDoubleImm1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    # kill: def $f1 killed $f1 def $vsl1
; CHECK-NEXT:    xxmrghd v2, v2, vs1
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testDoubleImm1:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    # kill: def $f1 killed $f1 def $vsl1
; CHECK-BE-NEXT:    xxpermdi v2, vs1, v2, 1
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testDoubleImm1:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    # kill: def $f1 killed $f1 def $vsl1
; CHECK-P9-NEXT:    xxpermdi v2, vs1, v2, 1
; CHECK-P9-NEXT:    blr
entry:
  %vecins = insertelement <2 x double> %a, double %b, i32 0
  ret <2 x double> %vecins
}

define <2 x double> @testDoubleImm2(<2 x double> %a, i32* %b) {
; CHECK-LABEL: testDoubleImm2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd f0, 0(r5)
; CHECK-NEXT:    xxmrghd v2, v2, vs0
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testDoubleImm2:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lfd f0, 0(r5)
; CHECK-BE-NEXT:    xxpermdi v2, vs0, v2, 1
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testDoubleImm2:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lfd f0, 0(r5)
; CHECK-P9-NEXT:    xxpermdi v2, vs0, v2, 1
; CHECK-P9-NEXT:    blr
entry:
  %0 = bitcast i32* %b to double*
  %1 = load double, double* %0, align 8
  %vecins = insertelement <2 x double> %a, double %1, i32 0
  ret <2 x double> %vecins
}

define <2 x double> @testDoubleImm3(<2 x double> %a, i32* %b) {
; CHECK-LABEL: testDoubleImm3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd f0, 4(r5)
; CHECK-NEXT:    xxmrghd v2, v2, vs0
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testDoubleImm3:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lfd f0, 4(r5)
; CHECK-BE-NEXT:    xxpermdi v2, vs0, v2, 1
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testDoubleImm3:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lfd f0, 4(r5)
; CHECK-P9-NEXT:    xxpermdi v2, vs0, v2, 1
; CHECK-P9-NEXT:    blr
entry:
  %add.ptr = getelementptr inbounds i32, i32* %b, i64 1
  %0 = bitcast i32* %add.ptr to double*
  %1 = load double, double* %0, align 8
  %vecins = insertelement <2 x double> %a, double %1, i32 0
  ret <2 x double> %vecins
}

define <2 x double> @testDoubleImm4(<2 x double> %a, i32* %b) {
; CHECK-LABEL: testDoubleImm4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    plfd f0, 262144(r5), 0
; CHECK-NEXT:    xxmrghd v2, v2, vs0
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testDoubleImm4:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    plfd f0, 262144(r5), 0
; CHECK-BE-NEXT:    xxpermdi v2, vs0, v2, 1
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testDoubleImm4:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lis r3, 4
; CHECK-P9-NEXT:    lfdx f0, r5, r3
; CHECK-P9-NEXT:    xxpermdi v2, vs0, v2, 1
; CHECK-P9-NEXT:    blr
entry:
  %add.ptr = getelementptr inbounds i32, i32* %b, i64 65536
  %0 = bitcast i32* %add.ptr to double*
  %1 = load double, double* %0, align 8
  %vecins = insertelement <2 x double> %a, double %1, i32 0
  ret <2 x double> %vecins
}

define <2 x double> @testDoubleImm5(<2 x double> %a, i32* %b) {
; CHECK-LABEL: testDoubleImm5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li r3, 1
; CHECK-NEXT:    rldic r3, r3, 38, 25
; CHECK-NEXT:    lfdx f0, r5, r3
; CHECK-NEXT:    xxmrghd v2, v2, vs0
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testDoubleImm5:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    li r3, 1
; CHECK-BE-NEXT:    rldic r3, r3, 38, 25
; CHECK-BE-NEXT:    lfdx f0, r5, r3
; CHECK-BE-NEXT:    xxpermdi v2, vs0, v2, 1
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testDoubleImm5:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    li r3, 1
; CHECK-P9-NEXT:    rldic r3, r3, 38, 25
; CHECK-P9-NEXT:    lfdx f0, r5, r3
; CHECK-P9-NEXT:    xxpermdi v2, vs0, v2, 1
; CHECK-P9-NEXT:    blr
entry:
  %add.ptr = getelementptr inbounds i32, i32* %b, i64 68719476736
  %0 = bitcast i32* %add.ptr to double*
  %1 = load double, double* %0, align 8
  %vecins = insertelement <2 x double> %a, double %1, i32 0
  ret <2 x double> %vecins
}

define dso_local <4 x float> @testInsertDoubleToFloat(<4 x float> %a, double %b) local_unnamed_addr #0 {
; CHECK-LABEL: testInsertDoubleToFloat:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xscvdpsp f0, f1
; CHECK-NEXT:    xxinsertw v2, vs0, 8
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: testInsertDoubleToFloat:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xscvdpsp f0, f1
; CHECK-BE-NEXT:    xxinsertw v2, vs0, 4
; CHECK-BE-NEXT:    blr
;
; CHECK-P9-LABEL: testInsertDoubleToFloat:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    xscvdpsp f0, f1
; CHECK-P9-NEXT:    xxinsertw v2, vs0, 4
; CHECK-P9-NEXT:    blr
entry:
  %conv = fptrunc double %b to float
  %vecins = insertelement <4 x float> %a, float %conv, i32 1
  ret <4 x float> %vecins
}
