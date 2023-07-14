* @ValidationCode : MjoxNzI2OTkyNjI1OkNwMTI1MjoxNjgyNDEyMzM5NjE1OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUTH.GARNISHMENT.MAINT
*------------------------------------------------------------------------
*DESCRIPTION
*This is an authorization routine for the version AC.LOCKED.EVENTS,INPUT
*------------------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : BHARATH C
* Program Name  : REDO.V.INP.GARNISHMENT.MAINT
* ODR NUMBER    : ODR-2009-10-0531
* Linked With   : authorization routine for AC.LOCKED.EVENTS,INPUT version
*----------------------------------------------------------------------
*Input param = none
*output param =none
*-----------------------------------------------------------------------
*MODIFICATION:
*   DATE           ODR
*19.1.2010     ODR-2009-10-0531
*21-02-2011        Prabhu.N         B.88-HD1040884      LOCAL REFERENCE ADDED
*-----------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM SM TO @SM
*10-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*----------------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.ACCOUNT

    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS
RETURN

*------------------------------
INIT:
    GARNISHMENT.VAL=''
    STATUS2.COUNT=''
    TEMP=''
RETURN
*-----------------------------
OPENFILE:
    FN.AC.LOCKED.EVENTS='F.AC.LOCKED.EVENTS$NAU'
    F.AC.LOCKED.EVENTS=''
    R.AC.LOCKED.EVENTS=''
    ERR.AC.LOCKED.EVENTS=''
    AC.LOCKED.ID=''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

*------------B.88-HD1040884--------------------------
*get the position of the local ref fields
*-----------------------------------------------------
    LREF.APP='ACCOUNT':@FM:'AC.LOCKED.EVENTS'
    LREF.FIELD='L.AC.STATUS2':@FM:'L.AC.LOCKE.TYPE'
    Y.REF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,Y.REF.POS)
    LOC.POS=Y.REF.POS<1,1>
    Y.TYPE.POS=Y.REF.POS<2,1>
*----------------------------------------------------------
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    R.ACCOUNT=''
    ERR.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN
*------------------------

PROCESS:

    AC.LOCKED.ID=ID.NEW
    ACCOUNT.ID=R.NEW(AC.LCK.ACCOUNT.NUMBER)
    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    STATUS2.VALUE.ALL=R.ACCOUNT<AC.LOCAL.REF,LOC.POS>
    STATUS2.COUNT=DCOUNT(STATUS2.VALUE.ALL,@SM)
    RECORD.STATUS  = R.ACCOUNT<AC.RECORD.STATUS>
    RECORD.STATUS=RECORD.STATUS[1,1]
    Y.LOCK.TYPE=R.NEW(AC.LCK.LOCAL.REF)<1,Y.TYPE.POS>
    IF STATUS2.COUNT EQ '0' THEN
        R.ACCOUNT<AC.LOCAL.REF,LOC.POS>=Y.LOCK.TYPE
    END
    ELSE
        LOCATE Y.LOCK.TYPE IN STATUS2.VALUE.ALL SETTING Y.ACC.STATUS.POS THEN
            R.ACCOUNT<AC.LOCAL.REF,LOC.POS,-1>=Y.LOCK.TYPE
        END
    END
    CALL F.LIVE.WRITE(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT)
RETURN
*--------------------
END
