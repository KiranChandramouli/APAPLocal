* @ValidationCode : MjoxODg5OTE2NjA5OkNwMTI1MjoxNjkxNTY2NjExNzQ5OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Aug 2023 13:06:51
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
$PACKAGE APAP.LAPAP

SUBROUTINE LAPAP.BULK.PR.NAU.P.RT.LOAD
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 09-AUG-2023      Harsha                R22 Manual Conversion - BP removed from Inserts
        
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_F.DATES
    $INSERT I_F.LAPAP.BULK.PAYROLL
    $INSERT I_F.ST.LAPAP.BULK.PAYROLL.DET
    $INSERT I_LAPAP.BULK.PR.NAU.P.RT.COMMON

    GOSUB DO.INITIALIZE
    GOSUB GET.LRT

RETURN

DO.INITIALIZE:

    CALL OCOMO('Waiting 15 minutes before the execution of LAPAP.BULK.PR.NAU.P.RT in order to allow previous OFS processing')
    SLEEP 900
    CALL OCOMO('Continue running the service')

    FN.BPRD = 'FBNK.ST.LAPAP.BULK.PAYROLL.DET'
    F.BPRD = ''
    CALL OPF(FN.BPRD,F.BPRD)

    FN.FT = 'FBNK.FUNDS.TRANSFER'
    F.FT = ''
    CALL OPF(FN.FT,F.FT)

    FN.FTNAU = 'FBNK.FUNDS.TRANSFER$NAU'
    F.FTNAU = ''
    CALL OPF(FN.FTNAU,F.FTNAU)

    Y.TODAY.DATE = R.DATES(EB.DAT.TODAY)
*R.DATES(EB.DAT.JULIAN.DATE)
    GRE.DATE = Y.TODAY.DATE
    JUL.DATE = ""
    CALL JULDATE(GRE.DATE,JUL.DATE)
    Y.JULIAN.DATE = RIGHT(JUL.DATE,5)
RETURN

GET.LRT:
    APPL.NAME.ARR = "FUNDS.TRANSFER"
    FLD.NAME.ARR = "L.COMMENTS" : @VM : "L.PAYROLL.ID"
    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)
    Y.L.COMMENTS.POS = FLD.POS.ARR<1,1>
    Y.L.PAYROLL.ID.POS = FLD.POS.ARR<1,2>


RETURN

END
