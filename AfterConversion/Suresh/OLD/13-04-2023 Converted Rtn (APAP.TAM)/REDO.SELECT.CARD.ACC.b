* @ValidationCode : MjotMTEzNzg3MzYxMzpDcDEyNTI6MTY4MTM4MTA0MzMyMzozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Apr 2023 15:47:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.SELECT.CARD.ACC(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.SELECT.CARD.ACC
*----------------------------------------------------------

* Description   : This subroutine is attached as a conversion routine in the Enquiry REDO.E.AA.ARR.ACTIVITY
*                 to get the old properrty list

* Linked with   : Enquiry REDO.SELECT.CARD.ACC as conversion routine
* In Parameter  : None
* Out Parameter : None
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*10.10.2010  PRABHU N      ODR-2010-08-0031   INITIAL CREATION
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION        FM TO @FM, VM TO @VM, SM TO @SM, IF CONDITION ADDED
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_System

    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----
INIT:
*-----

    FN.CUSTOMER.ACC='F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACC=''
    CALL OPF(FN.CUSTOMER.ACC,F.CUSTOMER.ACC)
    Y.VAR.EXT.CUSTOMER = System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*AUTO R22 CODE CONVERSION - START
        Y.VAR.EXT.CUSTOMER = ""
    END ;*AUTO R22 CODE CONVERSION - END
    CALL F.READ(FN.CUSTOMER.ACC,Y.VAR.EXT.CUSTOMER,R.CUSTOMER.ACC,F.CUSTOMER.ACC,ERR)
RETURN
*-------
PROCESS:
*-------
    CHANGE @FM TO @SM IN R.CUSTOMER.ACC
    Y.FIELD.COUNT=DCOUNT(ENQ.DATA<1>,@VM)
    ENQ.DATA<2,1>= 'ACCOUNT'
    ENQ.DATA<3,1>= 'EQ'
    ENQ.DATA<4,1>= R.CUSTOMER.ACC
RETURN
END
