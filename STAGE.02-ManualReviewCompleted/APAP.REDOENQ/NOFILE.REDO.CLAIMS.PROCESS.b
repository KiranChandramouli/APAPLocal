* @ValidationCode : MjoxNTgxMzAxNjY6Q3AxMjUyOjE2ODA3NzI3MDE4NjY6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 14:48:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE NOFILE.REDO.CLAIMS.PROCESS(Y.ARRAY)
***********************************************************************

* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: NOFILE.REDO.CLAIMS.PROCESS
* ODR NO      : ODR-2009-12-0283
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*16.08.2012  S SUDHARSANAN   ODR-2009-12-0283    INITIAL CREATION
*  DATE             WHO                   REFERENCE 
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - FM to @FM and ++ to +=1 
* 06-APRIL-2023      Harsha                R22 Manual Conversion - Added APAP.REDOENQ
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_ENQUIRY.COMMON
*
    GOSUB INIT
    GOSUB GET.CLAIM.IDS
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

    FN.REDO.ISSUE.CLAIMS = 'F.REDO.ISSUE.CLAIMS'
    F.REDO.ISSUE.CLAIMS = ''
    CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)

RETURN
*----------------------------------------------------------------------
GET.CLAIM.IDS:
*----------------------------------------------------------------------
* All selection fields related to REDO.ISSUE.CLAIMS application are processed here

    FILE.NAME = FN.REDO.ISSUE.CLAIMS
    IN.FIXED = "STATUS EQ OPEN"
    CALL APAP.REDOENQ.REDO.E.FORM.SEL.STMT(FILE.NAME, IN.FIXED, '', SEL.CLAIM.CMD)   ;*R22 Manual Conversion - Added APAP.REDOFCFI
    CALL EB.READLIST(SEL.CLAIM.CMD,CLAIM.ID.LST,'',NO.OF.REC.CLAIM,SEL.ERR)
    Y.COMMON.ARRAY = CLAIM.ID.LST
RETURN

*-------------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------------------
    Y.ARRAY.CNT = DCOUNT(Y.COMMON.ARRAY,@FM)
    VAR2=1
    LOOP
    WHILE VAR2 LE Y.ARRAY.CNT

        Y.ISSUE.CLAIMS.ID = Y.COMMON.ARRAY<VAR2>      ;*************3RD FILED
        CALL F.READ(FN.REDO.ISSUE.CLAIMS,Y.ISSUE.CLAIMS.ID,R.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS,CLAIMS.ERR)
        Y.CUSTOMER.CODE = R.REDO.ISSUE.CLAIMS<ISS.CL.CUSTOMER.CODE>       ;**********1ST FIELD
        Y.STATUS = R.REDO.ISSUE.CLAIMS<ISS.CL.STATUS> ;**********4TH FIELD
        Y.CUSTOMER.ID.NO = R.REDO.ISSUE.CLAIMS<ISS.CL.CUST.ID.NUMBER>     ;**********2ND FIELD
        Y.SUPP.GRP          = R.REDO.ISSUE.CLAIMS<ISS.CL.SUPPORT.GROUP>  ;          ;**********5TH FIELD
        Y.ARRAY<-1> = Y.CUSTOMER.CODE:'*':Y.CUSTOMER.ID.NO:'*':Y.ISSUE.CLAIMS.ID:'*':Y.STATUS:'*':Y.SUPP.GRP
        VAR2 += 1
    REPEAT
RETURN
*--------------------------------------------------------------------------------------------------------------
END
