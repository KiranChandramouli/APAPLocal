* @ValidationCode : MjoyMDAwMTk3NjAwOkNwMTI1MjoxNjk4MjM2OTIyMTI3OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Oct 2023 17:58:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>-27</Rating>
*-----------------------------------------------------------------------------
*    SUBROUTINE ITSS.MF.CHECK.EXT.USERP(ACTION.INFO, PASSWORD, RESERVED.2, RESERVED.3, RESERVED.4, MOB.RESPONSE, MOB.ERROR)
    SUBROUTINE ITSS.MF.CHECK.EXT.USERP(ACTION.INFO, PASSWORD, MOB.RESPONSE, MOB.ERROR)
*---------------------------------------------------------------------------------------------------
* Description: This routine is used to validate the internet user password provided from mobile app.
*              Routine bypasses ARC-IB user license.
*              OFS.SOURCE format:
*              SOURCE.TYPE=TELNET, LOGIN.ID=any, SYNTAX.TYPE=OFS, GENERIC.USER=TEMENOS01,
*              ATTRIBUTES=INTERFACE, SAME.AUTHORISER=YES, CHANNEL=INTERNET

*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                NO CHANGES
*-----------------------------------------------------------------------------------------------------------------------------------
*
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.OFS.SOURCE
    $INSERT I_F.CUSTOMER
    $INSERT I_EB.MOB.FRMWRK.COMMON
    $INSERT I_F.EB.EXTERNAL.USER
    $INSERT I_F.USER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.UI.BEHAVIOUR
*---------------------------------------------------------------------------------------------------

    GOSUB INITIALISE

    IF NOT(MOB.ERROR) THEN
        GOSUB PROCESS
    END

    RETURN
*---------------------------------------------------------------------------------------------------
INITIALISE:
*----------

*    USER.NAME = ACTION.INFO[',', 2, 1]
    USER.NAME = EXT.USER.ID

    MOB.ERROR = ''
    MOB.RESPONSE = ''

    MOB.RESPONSE<1, 1, 1> = 'SUCCESS'
    MOB.RESPONSE<1, 1, 2> = 'USER.NAME'
    MOB.RESPONSE<1, 1, 3> = 'LAST.SIGN.ON'
    MOB.RESPONSE<1, 1, 4> = 'COMPANY'
    MOB.RESPONSE<1, 1, 5> = 'CUSTOMER.NUMBER'
    MOB.RESPONSE<1, 1, 6> = 'USER.PROFILE'

    EXT.USER.NAME = R.EB.EXTERNAL.USER<EB.XU.NAME>
    CUSTOMER.NO = R.EB.EXTERNAL.USER<EB.XU.CUSTOMER>
    Y.ID.ARRANGEMENT = R.EB.EXTERNAL.USER<EB.XU.ARRANGEMENT,1,1>

*    LAST.DATE = R.EB.EXTERNAL.USER<EB.XU.DATE.LAST.USE, 1>
*    LAST.SIGN.ON.DATE = LAST.DATE[7,2]:'/':LAST.DATE[5,2]:'/':LAST.DATE[3,2]
    LAST.SIGN.ON.DATE = R.EB.EXTERNAL.USER<EB.XU.DATE.LAST.USE, 1>[1,8]

    LAST.TIME = R.EB.EXTERNAL.USER<EB.XU.TIME.LAST.USE, 1>
    LAST.SIGN.ON.TIME = LAST.TIME[1,2]:'-':LAST.TIME[3,2]

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)

    E.CUST = ''
    CALL F.READ(FN.CUSTOMER, CUSTOMER.NO, R.CUSTOMER, F.CUSTOMER, E.CUST)

    IF NOT(E.CUST) THEN
        CUSTOMER.BRANCH = R.CUSTOMER<EB.CUS.COMPANY.BOOK>
    END ELSE
        MOB.ERROR = 'MISSING CUSTOMER RECORD - ':CUSTOMER.NO
    END

    RETURN

*---------------------------------------------------------------------------------------------------
PROCESS:
*-------

    GOSUB SAVE.COMMON

    CALL VALIDATE.SIGN.ON(USER.NAME, PASSWORD)    ;* Validates Internet user/password.

*    Y.NAME = "EXT.EXTERNAL.USER"
*    CALL  System.getUserVariables(Y.NAME ,Y.NAME.1)

*    CRT Y.NAME
*    CRT Y.NAME.1

    IF ETEXT THEN
*        GOSUB CHECK.SIGN.ON.RTN
        GOSUB CHECK.ACT.ERROR
        GOSUB PROCESS.ERROR
        MOB.ERROR = ETEXT
        ETEXT = ''
*        MOB.ERROR = 'INVALID USER.ID/PASSWORD'    ;* MOB.ERROR =1 - failure, MOB.RESPONSE=0 - success.
        MOB.RESPONSE<1, 2, 1> = 1
        ETEXT = ''
    END ELSE
        MOB.RESPONSE<1, 2, 1> = 0
        MOB.RESPONSE<1, 2, 2> = EXT.USER.NAME
        MOB.RESPONSE<1, 2, 3> = LAST.SIGN.ON.DATE:' ':LAST.SIGN.ON.TIME
        MOB.RESPONSE<1, 2, 4> = CUSTOMER.BRANCH
        MOB.RESPONSE<1, 2, 5> = CUSTOMER.NO

        AA.ID = Y.ID.ARRANGEMENT
        ARR.ID= Y.ID.ARRANGEMENT
        PROPERTY.CLASS = "UI.BEHAVIOUR"
        AA.ID:='//AUTH'       ;*read the auth record first
        CALL AA.GET.ARRANGEMENT.CONDITIONS(AA.ID,PROPERTY.CLASS,'','',ARR.ID,PROPERTY.RECORD,ETEXT)
        CF$UI.BEHAVIOUR = RAISE(PROPERTY.RECORD)
        IF CF$UI.BEHAVIOUR<UI.BEHAV.FLOW.VALUE,1,1> EQ 'COS AI.REDO.PERSONAL.HOME.WITHOUT.TXN' THEN
            MOB.RESPONSE<1, 2, 6> =  'VIEW'
        END
        ELSE
            MOB.RESPONSE<1, 2, 6> =  'TXN'
        END
    END

    GOSUB RESTORE.COMMON

    RETURN

*---------------------------------------------------------------------------------------------------
SAVE.COMMON:

    SAVE.LOC.OPERATOR = OPERATOR

    GOSUB SET.SIGN.ON.COMMON

    SAVE.R.USER = R.USER

    OFS$SOURCE.REC<OFS.SRC.CHANNEL> = 'INTERNET'  ;* Just tell VSO that we are validating EB.EXTERNEL.USER

    ACT.SOURCE.TYPE = OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE>

    RETURN

*---------------------------------------------------------------------------------------------------
RESTORE.COMMON:
*--------------

    OPERATOR = SAVE.LOC.OPERATOR

    R.USER = SAVE.R.USER

    OFS$SOURCE.REC<OFS.SRC.CHANNEL> = ''          ;* Reset back once the user is authenticated.

    OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE> = ACT.SOURCE.TYPE

    RETURN

*---------------------------------------------------------------------------------------------------
SET.SIGN.ON.COMMON:
*------------------

    OPERATOR = OFS$SOURCE.REC<OFS.SRC.GENERIC.USER>

    RETURN

*---------------------------------------------------------------------------------------------------
*CHECK.SIGN.ON.RTN:
*-----------------

*    IF R.USER<EB.USE.SIGN.ON.RTN> NE '' THEN

*        SIGN.ON.RTN.LIST =  R.USER<EB.USE.SIGN.ON.RTN>      ;* get the sign on routines list

*        LOOP
*            REMOVE SIGN.ON.RTN FROM SIGN.ON.RTN.LIST SETTING POS      ;* get each sign on routine
*        WHILE SIGN.ON.RTN
*            CALL EB.CALL.API(SIGN.ON.RTN,'')      ;* execute the sign on routine via EB.API
*            IF ETEXT THEN     ;* if error is set
*                ETEXT = 'EB-SIGN.ON.RTN.ERROR'
*                RETURN        ;* break out of the loop
*            END
*        REPEAT
*    END

*    RETURN

*---------------------------------------------------------------------------------------------------
CHECK.ACT.ERROR:
*---------------

    GOSUB SET.SIGN.ON.COMMON

    ETEXT = ''

    TEXT = ''

    OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE> = 'SESSION'         ;* Just tell VSO that we are validating EB.EXTERNEL.USER

    CALL VALIDATE.SIGN.ON(USER.NAME, PASSWORD)

    GOSUB RESTORE.COMMON

    IF ETEXT EQ '' AND TEXT NE '' THEN ETEXT = TEXT

    RETURN

*---------------------------------------------------------------------------------------------------
PROCESS.ERROR:
*-------------

    CALL STORE.END.ERROR

    RETURN

*---------------------------------------------------------------------------------------------------
END
