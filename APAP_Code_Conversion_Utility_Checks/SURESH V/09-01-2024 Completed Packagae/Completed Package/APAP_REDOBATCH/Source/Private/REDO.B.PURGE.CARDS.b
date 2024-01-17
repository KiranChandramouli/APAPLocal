* @ValidationCode : MjotMTE3OTQ2OTQxNzpDcDEyNTI6MTY4NDg1NDM5NDgwMDpJVFNTOi0xOi0xOjE3MjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 172
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.PURGE.CARDS(Y.ID)
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.PURGE.CARDS
*--------------------------------------------------------------------------------------------------------
*Description       : This routine is COB routine to purge cancelled cards with Daily frequency
*In Parameter      :
*Out Parameter     :
*Files  Used       :
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  30/07/2010       REKHA S            ODR-2010-03-0400 B166      Initial Creation
* Date                  who                   Reference              
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.NO.LOCK
    $INSERT I_REDO.B.PURGE.CARDS.COMMON
    $INSERT I_F.DATES
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.CARD.TYPE



    GOSUB INIT
    GOSUB PROCESS

RETURN

****
INIT:
*****
    Y.CARD.TYPE = ''
    Y.PURGE.FQU = ''
    Y.CAN.DATE = ''

RETURN

********
PROCESS:
********
*Check purge cancellation of cards with Daily frequency

    Y.CARD.TYPE = FIELD(Y.ID,'.',1,1)
    CALL F.READ(FN.CARD.TYPE,Y.CARD.TYPE,R.CARD.TYPE,F.CARD.TYPE,Y.CARD.ERR)
    Y.PURGE.FQU = R.CARD.TYPE<CARD.TYPE.LOCAL.REF><1,LOC.L.CT.PURGE.FQU>
    Y.PURGE.FQU = Y.PURGE.FQU
*   Y.PURGE.FQU = '+':Y.PURGE.FQU
    DISP = '+'

    CALL F.READ(FN.LATAM.CARD.ORDER,Y.ID,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER,Y.CAD.ERR)
    Y.CAN.DATE = R.LATAM.CARD.ORDER<CARD.IS.CANCELLATION.DATE>
*   CALL CDT('',Y.CAN.DATE,Y.PURGE.FQU)
*Y.PURGE.DATE = Y.CAN.DATE
*>>>>>>>>>>>>>>>>>>>>>>>>> CHANGES DONE>>>>>>>>>>>>>>>>>>>>>

    CALL CALENDAR.DAY(Y.CAN.DATE, DISP, Y.PURGE.FQU)
    Y.PURGE.DATE = Y.PURGE.FQU
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    Y.LAST.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)

    IF Y.PURGE.DATE EQ Y.LAST.DAY THEN
        GOSUB REV.LATAM.CARD.ORDER
    END
RETURN

*********************
REV.LATAM.CARD.ORDER:
*********************
*OFS process to reverse LATAM.CARD.ORDER cards
    OFS.SRC.ID = "DEBIT.CARD"
    OFS.MSG.ID = ''
    ERR.OFS = ''

    APP.NAME = 'LATAM.CARD.ORDER'
    OFSFUNCTION = 'R'
    PROCESS = 'PROCESS'
    OFS.VERSION ='LATAM.CARD.ORDER,PRINCIPAL'
    GTS.MODE = ''
    NO.OF.AUTH = '0'
    TRANSACTION.ID = Y.ID
    R.ACC = ''
    OFSRECORD = ''

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCTION,PROCESS,OFS.VERSION,GTS.MODE,NO.OF.AUTH,TRANSACTION.ID,R.ACC,OFSRECORD)
    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SRC.ID,ERR.OFS)
RETURN
END
