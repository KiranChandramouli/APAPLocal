* @ValidationCode : MjotNTc0MzE3MDcwOkNwMTI1MjoxNjgyNTE4ODgwNzE5OklUU1M6LTE6LTE6NDUwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Apr 2023 19:51:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 450
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     IF BLOCK ADDED, FM TO @FM, VM TO @VM
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.V.ID.STATUS.CHECK
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is ID routine attached to TELLER, CUSTOMER, ACCOUNT, FUNDS.TRANSFER,
*USER and TELLER.ID version to prevent transaction input if status is closed
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY :
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 04-Jan-2010        Ganesh R                            Initial Creation
*------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.BRANCH.STATUS
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.EXCEP.REC.PARAM
    $INSERT I_System
    $INSERT I_GTS.COMMON

*
    $INSERT I_F.BROWSER.TOOLS
*
    GOSUB INIT
    GOSUB OPEN.FILES

    GOSUB PRE.PROCESS
    CALL CACHE.READ(FN.REDO.EXCEP.REC.PARAM,'SYSTEM',R.REDO.EXCEP.REC.PARAM,EXCEP.ERR)
    Y.APPLICATION.LIST  = R.REDO.EXCEP.REC.PARAM<EXCEP.APPLICATION.NAME>
    Y.GENERIC.USER      = R.REDO.EXCEP.REC.PARAM<EXCEP.GENERIC.USER>
    CHANGE @VM TO @FM IN Y.APPLICATION.LIST ;*R22 AUTO CONVERSION
    IF Y.GENERIC.USER THEN
        IF OPERATOR MATCHES Y.GENERIC.USER THEN
            RETURN        ;* Need not to raise in case of OFS/Generic user.
        END
    END
    LOCATE APPLICATION IN Y.APPLICATION.LIST SETTING APP.POS THEN
        IF (Y.FUNCTION EQ "I" OR Y.FUNCTION EQ "A") THEN
            GOSUB PROCESS
        END
    END

RETURN

*----*
INIT:
*----*
*-----------*
*Initialising
*-----------*

    CALL EB.CHANGE.TOOL("CONTRACT", "TXN.DEAL.SLIP.PRINT", BRTL.ENABLED, "YES")   ;* VNL - 2012JAN11 - S/E
*    CALL EB.ADD.TOOLBAR("PRINT.CLAIM", 'HEADER')

    Y.FUNCTION = V$FUNCTION     ;* PACS00245098 - S/E
RETURN

*---------*
OPEN.FILES:
*---------*
*------------*
*Opening files
*------------*
    FN.BR.STATUS='F.REDO.BRANCH.STATUS'
    F.BR.STATUS=''
    CALL OPF(FN.BR.STATUS,F.BR.STATUS)
* PACS00245098 - S
    FN.TELLER.HIS = 'F.TELLER$HIS'
    F.TELLER.HIS = ''
    CALL OPF(FN.TELLER.HIS,F.TELLER.HIS)
* PACS00245098 - E

*
    FN.BRANCH.UNAUTH.LIST = 'F.BRANCH.UNAUTH.LIST'
    F.BRANCH.UNAUTH.LIST  = ''
    CALL OPF(FN.BRANCH.UNAUTH.LIST,F.BRANCH.UNAUTH.LIST)
    R.BRANCH.UNAUTH.LIST = ''

    FN.REDO.EXCEP.REC.PARAM = 'F.REDO.EXCEP.REC.PARAM'
    F.REDO.EXCEP.REC.PARAM = ''
    CALL OPF(FN.REDO.EXCEP.REC.PARAM,F.REDO.EXCEP.REC.PARAM)
RETURN
*-----------*
PRE.PROCESS:
*-----------*
* PACS00245098 - S
    IF Y.FUNCTION EQ "R" THEN
        R.TELLER.HIS = ''
        Y.TT.ID      = COMI
        CALL EB.READ.HISTORY.REC(F.TELLER.HIS,Y.TT.ID,R.TELLER.HIS,TT.ERR.HIS)
        IF R.TELLER.HIS THEN
            E="EB-TRANSACTION.NOT.ALLOWED"
            CALL STORE.END.ERROR
        END
    END
*  PACS00245098 - E
RETURN
*
*-------*
PROCESS:
*-------*
*-----------------------------------------------------*
*Raising Error Message if the operation Status is Closes
*-----------------------------------------------------*
    REC.ID = System.getVariable("CURRENT.USER.BRANCH")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CONVERSION START
        REC.ID = ""
    END ;*R22 AUTO CONVERSION END

    IF REC.ID EQ "CURRENT.USER.BRANCH" THEN
        LOCATE 'EB-UNKNOWN.VARIABLE' IN E<1,1> SETTING POS THEN
            E = ''
        END
        RETURN
    END ELSE
        CALL F.READ(FN.BR.STATUS,REC.ID,R.BR.STATUS,F.BR.STATUS,BR.MSG)
        VA.OPR.STATUS=R.BR.STATUS<BR.ST.OPERATION.STATUS>

        IF VA.OPR.STATUS EQ "CLOSED" THEN
            E="EB-STATUS.CLOSED"
            CALL STORE.END.ERROR
        END
    END

RETURN
END
