* @ValidationCode : Mjo0Njk0NTY4MjpDcDEyNTI6MTY5NjQ5MTg4NzcxMzphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Oct 2023 13:14:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
SUBROUTINE REDO.VI.ATH.REJECT
 
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.VI.ATH.APPROVE
***********************************************************************************
*Description: * This is a version routine attached to approval version of ATH settelement process to
* review and approve the settlement.
*****************************************************************************
*linked with:
*In parameter:
*Out parameter:
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*23.04.2012   BALAGURUNATHAN  ODR-2010-08-0469  INITIAL CREATION
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             FM TO @FM
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CURRENCY
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_F.REDO.ATH.SETTLMENT
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_F.REDO.ATH.STLMT.PARAM


    GOSUB INIT
    GOSUB PROCESS



RETURN

*----------------------------------------------------------
INIT:
*----------------------------------------------------------


    TRANSACTION.ID = ''
    PROCESS = ''
    GTSMODE  =''
    OFSRECORD  = ''
    OFS.MSG.ID = ''
    OFS.ERR = ''
    OFS.STRING = ''
    OFS.ERR = ''

    FN.ATM.REVERSAL = 'F.ATM.REVERSAL'
    F.ATM.REVERSAL  =''
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)

    FN.ACCOUNT ='F.ACCOUNT'
    F.ACCOUNT =''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AC.LOCKED.EVENTS='F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS=''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

    FN.REDO.APAP.H.PARAMETER='F.REDO.APAP.H.PARAMETER'
    FN.REDO.ATH.STLMT.PARAM='F.REDO.ATH.STLMT.PARAM'


RETURN
*----------------------------------------------------------
PROCESS:
*----------------------------------------------------------

    CARD.NUMBER=R.NEW(ATH.SETT.CARD.ACC.NO.TRAN)

    ATM.REVERSAL.ID=CARD.NUMBER:'.':R.NEW(ATH.SETT.AUTH.CODE)
    CALL F.READ(FN.ATM.REVERSAL,ATM.REVERSAL.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ATM.REVERSAL.ERR)

    Y.LOCK.ID=R.ATM.REVERSAL<AT.REV.TRANSACTION.ID>
    CALL F.READ(FN.AC.LOCKED.EVENTS,Y.LOCK.ID,R.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS,ERR)
    Y.CHARGE.AMT=R.AC.LOCKED.EVENTS<AC.LCK.LOCAL.REF,POS.L.TXN.CHG.LOCAL>

    IF R.ATM.REVERSAL<AT.REV.TXN.REF> NE '' AND R.ATM.REVERSAL<AT.REV.TXN.REF>[1,4] NE 'ACLK' THEN
        RETURN
    END

    GOSUB PROCESS.NEXT

RETURN


*----------------------------------------------------------
PROCESS.NEXT:
*----------------------------------------------------------
    GOSUB GET.LOCAL.REF

    PARAMETER.ID = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.APAP.H.PARAMETER,PARAMETER.ID,R.REDO.APAP.H.PARAMETER,PARAMETER.ERROR)

    TC.CODE = R.NEW(ATH.SETT.MSG.TYPE)


    Y.TC.CODE=R.REDO.APAP.H.PARAMETER<PARAM.TC.CODE>

    LOCATE TC.CODE IN Y.TC.CODE<1,1> SETTING POS1 THEN

        DR.ACCT=R.REDO.APAP.H.PARAMETER<PARAM.DR.ACCT,POS1>

        MODIFY.RTN=R.REDO.APAP.H.PARAMETER<PARAM.MODIFY.RTN,POS1>
        Y.FT.VERSION= R.REDO.APAP.H.PARAMETER<PARAM.FT.VERSION,POS1>
        Y.AC.LOCK.VERSION= R.REDO.APAP.H.PARAMETER<PARAM.AC.LCK.REV.VERSION,POS1>
    END

    GOSUB OFS.POST

RETURN


*----------------------------------------------------------------------
OFS.POST:
*----------------------------------------------------------------------

    OFS.SRC='REDO.VISA.OUTGOING'

    APP.NAME ='AC.LOCKED.EVENTS'
    OFSFUNCT='R'
    PROCESS  = ''
    OFSVERSION = Y.AC.LOCK.VERSION
    GTSMODE = ''
    TRANSACTION.ID=R.ATM.REVERSAL<AT.REV.TRANSACTION.ID>
    OFSRECORD = ''
    OFS.MSG.ID =''
    OFS.ERR = ''
    NO.OF.AUTH='0'
    R.OFS.AC.LOCK=''
    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.OFS.AC.LOCK,OFSRECORD2)
    OFS.STRING.FINAL=OFSRECORD2
    CALL OFS.POST.MESSAGE(OFS.STRING.FINAL,OFS.MSG.ID,OFS.SRC,OPTIONS)

RETURN

*-----------------------------------------------------------
GET.LOCAL.REF:
*-----------------------------------------------------------

    LOC.REF.APPLICATION="ACCOUNT":@FM:"AC.LOCKED.EVENTS"
    LOC.REF.FIELDS='L.AC.AV.BAL':@FM:'L.TXN.CHG.LOCAL'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AC.AV.BAL=LOC.REF.POS<1,1>
    POS.L.TXN.CHG.LOCAL=LOC.REF.POS<2,1>
RETURN

END
