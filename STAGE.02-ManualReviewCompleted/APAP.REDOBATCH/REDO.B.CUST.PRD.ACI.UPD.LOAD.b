* @ValidationCode : MjoxNzI2NDY3MTgwOkNwMTI1MjoxNjgxMTg4MjgxMzU0OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 10:14:41
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
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CUST.PRD.ACI.UPD.LOAD
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.CUST.PRD.ACI.UPD.LOAD
* ODR Number    : ODR-2009-10-0317
*-------------------------------------------------------------------------
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 11-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - VM TO @VM
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
* Description :This routine will open all the files required
*              by the routine REDO.B.CUST.PRD.ACI.UPD.LOAD

* In parameter : None
* out parameter : None
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CREDIT.INT
    $INSERT I_F.BASIC.INTEREST
    $INSERT I_F.DATES
    $INSERT I_F.REDO.CUST.PRD.LIST
    $INSERT I_F.REDO.ACC.CR.INT
    $INSERT I_REDO.B.CUST.PRD.ACI.UPD.COMMON

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.CREDIT.INT='F.ACCOUNT.CREDIT.INT'
    F.ACCOUNT.CREDIT.INT=''
    CALL OPF(FN.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT)

    FN.REDO.ACC.CR.INT='F.REDO.ACC.CR.INT'
    F.REDO.ACC.CR.INT=''
    CALL OPF(FN.REDO.ACC.CR.INT,F.REDO.ACC.CR.INT)

    FN.BASIC.INTEREST='F.BASIC.INTEREST'
    F.BASIC.INTEREST=''
    CALL OPF(FN.BASIC.INTEREST,F.BASIC.INTEREST)

    FN.REDO.CUST.PRD.LIST='F.REDO.CUST.PRD.LIST'
    F.REDO.CUST.PRD.LIST=''
    CALL OPF(FN.REDO.CUST.PRD.LIST,F.REDO.CUST.PRD.LIST)

    LREF.APP='ACCOUNT'
    LREF.FIELD='L.AC.STATUS1':@VM:'L.STAT.INT.RATE':@VM:'L.DATE.INT.UPD':@VM:'L.AC.MAN.UPD'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    POS.L.AC.STATUS1=LREF.POS<1,1>
    POS.L.STAT.INT.RATE=LREF.POS<1,2>
    POS.L.DATE.INT.UPD=LREF.POS<1,3>
    POS.L.AC.MAN.UPD=LREF.POS<1,4>

*Shek -s
* new table
    FN.REDO.BATCH.JOB.LIST.FILE = 'F.REDO.BATCH.JOB.LIST.FILE'
    F.REDO.BATCH.JOB.LIST.FILE = ''
    CALL OPF(FN.REDO.BATCH.JOB.LIST.FILE, F.REDO.BATCH.JOB.LIST.FILE)
*Shek -e

RETURN
END
