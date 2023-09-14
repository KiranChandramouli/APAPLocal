* @ValidationCode : MjotMTY0Njk4MTk4MDpDcDEyNTI6MTY4MDc3NjM2MTEzNjpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:49:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.ANC.LOCKED.AMT
*-----------------------------------------------------------------------------------
*Description
*This is an authorization routine for the version AC.LOCKED.EVENTS,INPUT
*-----------------------------------------------------------------------------------
* Company Name  : APAP
* Developed By  : RAJASAKTHIVEL K P
* Program Name  : REDO.V.ANC.LOCKED.AMT
* ODR NUMBER    : ODR-2009-10-0531
* Linked with   : authorization routine for the version AC.LOCKED.EVENTS,INPUT
*----------------------------------------------------------------------
*Input param = none
*output param =none
*-----------------------------------------------------------------------
*MODIFICATION:
*   DATE           ODR
*20.1.2010     ODR-2009-10-0531
*-------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*06-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*06-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.APAP.H.GARNISH.DETAILS

    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS
RETURN

*------------------------------
INIT:
*------------------------------
    AC.LOCK.ID=''
    SEL.LOCKED.CMD=''
    AMOUNT.LOCK=''

RETURN
*------------------------------
OPENFILE:
*------------------------------


    FN.AC.LOCKED.EVENTS='F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS=''
    R.AC.LOCKED.EVENTS=''
    ERR.AC.LOCKED.EVENTS=''
    AC.LOCKED.ID=''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

RETURN
*-------------------------------
PROCESS:

    AC.LOCK.ID=ID.NEW
*--------------------------------------
* Selecting the required account
*--------------------------------------
    SEL.CMD = "SELECT ":FN.AC.LOCKED.EVENTS:" WITH L.AC.GAR.REF.NO EQ ":AC.LOCK.ID
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECORDS,RET.CODE)
    LOOP
        REMOVE Y.ACC.ID FROM SEL.LIST SETTING POS
    WHILE Y.ACC.ID:POS
        CALL F.READ(FN.AC.LOCKED.EVENTS,Y.ACC.ID,R.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS,ERR.AC.LOCKED.EVENTS)
        Y.LCK.AMT = R.AC.LOCKED.EVENTS<AC.LCK.LOCKED.AMOUNT>
    REPEAT
    R.NEW(APAP.GAR.AMOUNT.LOCKED)=Y.LCK.AMT
RETURN
*-----------------------------
END
