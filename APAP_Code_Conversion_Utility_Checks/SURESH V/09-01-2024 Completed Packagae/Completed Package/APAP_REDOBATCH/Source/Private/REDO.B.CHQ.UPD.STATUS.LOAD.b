* @ValidationCode : MjotMzc4NDI2NzE0OkNwMTI1MjoxNzAzMjIxOTk0MjI0OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 22 Dec 2023 10:43:14
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
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CHQ.UPD.STATUS.LOAD
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.CHQ.UPD.STATUS.LOAD
*--------------------------------------------------------------------------------------------------------
*Description       : Multi threaded routine used to initialise the variables.

*In  Parameter     :
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 17 OCT 2011        MARIMUTHU S              PACS00146454             Initial Creation
* 04-APR-2023     Conversion tool          R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*
*21/12/2023         Suresh             R22 Manual Conversion      IDVAR Variable Changed
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.CHQ.UPD.STATUS.COMMON

    GOSUB OPENFILES

OPENFILES:

    LOC.REF.APPLICATION   = "AA.PRD.DES.OVERDUE"
    LOC.REF.FIELDS        = 'L.LOAN.COND'
    LOC.REF.POS           = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.LOAN.COND     =      LOC.REF.POS<1,1>


    FN.REDO.LOAN.CHQ.RETURN = 'F.REDO.LOAN.CHQ.RETURN'
    F.REDO.LOAN.CHQ.RETURN = ''
    CALL OPF(FN.REDO.LOAN.CHQ.RETURN,F.REDO.LOAN.CHQ.RETURN)

    FN.REDO.APAP.CLEAR.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
    F.REDO.APAP.CLEAR.PARAM = ''
    CALL OPF(FN.REDO.APAP.CLEAR.PARAM, F.REDO.APAP.CLEAR.PARAM)

    IDVAR='SYSTEM' ;*R22 Manual Conversion
*    CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,'SYSTEM',R.REDO.APAP.CLEAR.PARAM,F.REDO.APAP.CLEAR.PARAM)
    CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,IDVAR,R.REDO.APAP.CLEAR.PARAM,F.REDO.APAP.CLEAR.PARAM) ;*R22 Manual Conversion

RETURN
END
