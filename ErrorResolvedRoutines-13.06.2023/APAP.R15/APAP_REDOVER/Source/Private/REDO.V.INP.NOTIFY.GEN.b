* @ValidationCode : MjoxNDk0NDk2NzQyOkNwMTI1MjoxNjg0ODQ1NjIwNjI2OklUU1M6LTE6LTE6ODUyOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 18:10:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 852
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.NOTIFY.GEN
*--------------------------------------------------------------------------------
*DESCRIPTION       :Input routine generates override message when there is notification
*in the account
*----------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 29-JUN-2010        Prabhu.N        HD1009868          Initial Creation
* 18-Apr-2011         H GANESH       PACS00033637       Changed made as per issue
* 21-Jul-2011        Ganesh R        PACS00033637       Changed the routine as per design
* 06-NOV-2011        Sudharsanan S   cr.18              Modify the code for deposit
*--------------------------------------------------------------------------------------------------

*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*12-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,SM TO @SM,++ TO +=1
*12-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*----------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.REDO.NOTIFY.STATUS.MESSAGE

    GOSUB INIT
    GOSUB FILEOPEN
    GOSUB PROCESS
RETURN
*----
INIT:
*----
    Y.FIELD.POS = ''
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP  = ''
    Y.FLAG.SET = ''
    FN.REDO.NOTIFY.STATUS.MESSAGE='F.REDO.NOTIFY.STATUS.MESSAGE'
    F.REDO.NOTIFY.STATUS.MESSAGE=''
    LREF.APP='ACCOUNT':@FM:'AZ.ACCOUNT':@FM:'EB.LOOKUP'
    LREF.FIELD='L.AC.NOTIFY.1':@FM:'L.AC.NOTIFY.1':@FM:'L.POST.RESTRICT'
    LREF.POS = ''
RETURN
*--------
FILEOPEN:
*--------
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.REDO.NOTIFY.STATUS.MESSAGE,F.REDO.NOTIFY.STATUS.MESSAGE)
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    ACC.NOTIFY.POS =LREF.POS<1,1>
    AZ.NOTIFY.POS = LREF.POS<2,1>
    POST.RESTRICT.POS = LREF.POS<3,1>
RETURN
*--------
PROCESS:
*--------
* This part checks the application and raise override accordingly

    CALL F.READ(FN.REDO.NOTIFY.STATUS.MESSAGE,APPLICATION,R.REDO.NOTIFY.STATUS,F.REDO.NOTIFY.STATUS,STATUS.ERR)
    CALL GET.STANDARD.SELECTION.DETS(APPLICATION,REC.STORE)
    IF R.REDO.NOTIFY.STATUS THEN
        Y.FIELD.POS.LIST = R.REDO.NOTIFY.STATUS<REDO.NOTIF.ACCT.FIELD.POS>
    END
    Y.TOTAL.FIELD.COUNT = DCOUNT(Y.FIELD.POS.LIST,@VM)
    Y.INIT = 1
    LOOP
        REMOVE Y.FIELD.POS FROM Y.FIELD.POS.LIST SETTING Y.FIND.POS
    WHILE Y.INIT LE Y.TOTAL.FIELD.COUNT
        Y.VAL.COUNT = DCOUNT(Y.FIELD.POS,',')
        IF Y.FIELD.POS NE '' THEN
            IF Y.VAL.COUNT EQ 2 THEN
                Y.FIRST.VAL  = FIELD(Y.FIELD.POS,',',1)
                Y.SECOND.VAL = FIELD(Y.FIELD.POS,',',2)
                Y.CR.DEB.ID  = R.NEW(Y.FIRST.VAL)<1,Y.SECOND.VAL>
            END
            IF Y.VAL.COUNT EQ 1 THEN
                Y.CR.DEB.ID  = R.NEW(Y.FIELD.POS)
            END
            IF Y.VAL.COUNT EQ 1 AND Y.FIELD.POS EQ 0 THEN
                Y.CR.DEB.ID = ID.NEW
            END
        END
        GOSUB CONT.PROC
        Y.INIT += 1
    REPEAT

    IF APPLICATION EQ 'ACCOUNT' THEN

        IF  Y.FLAG.SET THEN
            R.NEW(AC.POSTING.RESTRICT) = 50

        END
        ELSE
            IF R.NEW(AC.POSTING.RESTRICT) EQ "50" THEN
                R.NEW(AC.POSTING.RESTRICT)=''
            END
        END
    END

RETURN
************
CONT.PROC:
************
    USR.FIELD.NAME = ''
    USR.FIELD.NAME = REC.STORE<SSL.SYS.FIELD.NAME>
    CHANGE @VM TO @FM IN USR.FIELD.NAME

    LOCATE 'OVERRIDE' IN USR.FIELD.NAME SETTING LOC.POS THEN
        Y.OVERRIDE.POS = REC.STORE<SSL.SYS.FIELD.NO,LOC.POS,1>
    END
    GOSUB OVERRIDE.GEN

RETURN
*-----------
OVERRIDE.GEN:
*-----------
******CR.18-S*******


    BEGIN CASE
        CASE APPLICATION EQ "AZ.ACCOUNT"
            IF Y.VAL.COUNT EQ 1 AND Y.FIELD.POS EQ 0 THEN
                Y.NOTIFY.STATUS = R.NEW(AZ.LOCAL.REF)<1,AZ.NOTIFY.POS>
            END ELSE
                Y.NOTIFY.STATUS = ''
                CALL F.READ(FN.ACCOUNT,Y.CR.DEB.ID,R.ACCOUNT,F.ACCOUNT,CRE.ERR)
                IF R.ACCOUNT THEN
                    Y.NOTIFY.STATUS=R.ACCOUNT<AC.LOCAL.REF,ACC.NOTIFY.POS>
                END
            END
        CASE APPLICATION EQ "ACCOUNT"
            IF Y.VAL.COUNT EQ 1 AND Y.FIELD.POS EQ 0 THEN
                Y.NOTIFY.STATUS = R.NEW(AC.LOCAL.REF)<1,ACC.NOTIFY.POS>
            END ELSE
                Y.NOTIFY.STATUS = ''
                CALL F.READ(FN.ACCOUNT,Y.CR.DEB.ID,R.ACCOUNT,F.ACCOUNT,CRE.ERR)
                IF R.ACCOUNT THEN
                    Y.NOTIFY.STATUS=R.ACCOUNT<AC.LOCAL.REF,ACC.NOTIFY.POS>
                END
            END

        CASE APPLICATION EQ "STANDING.ORDER"

            Y.NOTIFY.STATUS = ''
            Y.CR.DEB.ID = FIELD(Y.CR.DEB.ID,'.',1)
            CALL F.READ(FN.ACCOUNT,Y.CR.DEB.ID,R.ACCOUNT,F.ACCOUNT,CRE.ERR)
            IF R.ACCOUNT THEN
                Y.NOTIFY.STATUS=R.ACCOUNT<AC.LOCAL.REF,ACC.NOTIFY.POS>
            END

        CASE OTHERWISE
            Y.NOTIFY.STATUS = ''
            CALL F.READ(FN.ACCOUNT,Y.CR.DEB.ID,R.ACCOUNT,F.ACCOUNT,CRE.ERR)
            IF R.ACCOUNT THEN
                Y.NOTIFY.STATUS=R.ACCOUNT<AC.LOCAL.REF,ACC.NOTIFY.POS>
            END
    END CASE
*****CR.18-E*******
    Y.NOTIFY.CNT=DCOUNT(Y.NOTIFY.STATUS,@SM)
    Y.VAR1=1

    LOOP
    WHILE Y.VAR1 LE Y.NOTIFY.CNT
        Y.NOTIFY=Y.NOTIFY.STATUS<1,1,Y.VAR1>
        GOSUB RAISE.OVERRIDE
        Y.VAR1 += 1
    REPEAT

RETURN

*-------------------
RAISE.OVERRIDE:
*-------------------
* This part gets the override message from REDO.NOTIFY.STATUS.MESSAGE application and raise the override

    Y.OVERRIDE   = R.REDO.NOTIFY.STATUS<REDO.NOTIF.OVERRIDE.MSG,Y.INIT>
    CHANGE @VM TO @FM IN Y.OVERRIDE
    Y.NOTIFY.MSG = R.REDO.NOTIFY.STATUS<REDO.NOTIF.NOTIFY.MSG,Y.INIT>
    CHANGE @VM TO @FM IN Y.NOTIFY.MSG

    LOCATE Y.NOTIFY IN Y.NOTIFY.MSG SETTING NOTIFY.POS THEN
        Y.OVERRIDE.ID=Y.OVERRIDE<1,NOTIFY.POS>
    END ELSE
        Y.OVERRIDE.ID=''
    END
    IF Y.OVERRIDE.ID THEN
        VIRTUAL.TAB.ID='L.AC.NOTIFY.1'
        CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
        Y.LOOKUP.LIST=VIRTUAL.TAB.ID<2>
        Y.LOOKUP.DESC=VIRTUAL.TAB.ID<11>
        CHANGE '_' TO @FM IN Y.LOOKUP.LIST
        CHANGE '_' TO @FM IN Y.LOOKUP.DESC
        LOCATE Y.NOTIFY IN Y.LOOKUP.LIST SETTING POS1 THEN
            IF R.USER<EB.USE.LANGUAGE> EQ 1 THEN        ;* This is for english user
                Y.MESSAGE=Y.LOOKUP.DESC<POS1,1>
            END
            IF R.USER<EB.USE.LANGUAGE> EQ 2 AND Y.LOOKUP.DESC<POS1,2> NE '' THEN
                Y.MESSAGE=Y.LOOKUP.DESC<POS1,2> ;* This is for spanish user
            END ELSE
                Y.MESSAGE=Y.LOOKUP.DESC<POS1,1>
            END
        END
        TEXT=Y.OVERRIDE.ID:@FM:Y.CR.DEB.ID:@VM:Y.MESSAGE
        CURR.NO=DCOUNT(R.NEW(Y.OVERRIDE.POS),@VM)+1
        CALL STORE.OVERRIDE(CURR.NO)

    END

    IF APPLICATION EQ 'ACCOUNT' THEN
        EB.LOOKUP.ID = 'L.AC.NOTIFY.1':'*':Y.NOTIFY
        CALL F.READ(F.EB.LOOKUP,EB.LOOKUP.ID,R.EB.LOOKUP,F.EB.LOOKUP,EB.LOOKUP.ERR)
        EB.LOOKUP.RESTRICTION = R.EB.LOOKUP<EB.LU.LOCAL.REF,POST.RESTRICT.POS>
        IF EB.LOOKUP.RESTRICTION EQ 'YES' THEN
            Y.FLAG.SET = 1
        END
    END



RETURN
END
