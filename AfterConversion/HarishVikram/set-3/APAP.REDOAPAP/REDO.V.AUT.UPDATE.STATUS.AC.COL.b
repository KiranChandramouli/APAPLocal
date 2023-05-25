* @ValidationCode : MjotNDM2MDUzMzM0OkNwMTI1MjoxNjg1MDE4ODc4MjA4OnZpY3RvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 May 2023 18:17:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.V.AUT.UPDATE.STATUS.AC.COL

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.USER
*-----------------------------------------------------------------------------
*22/09/11 RIYAS PACS00099905  change the L.AC.STATUS2 logic set for multi value field
*DATE          NAME                REFERENCE               DESCRIPTION
*31 JAN 2023   Edwin Charles D     ACCOUNTING-CR           TSR479892
*25-05-2023    CONVERSION TOOL     R22 AUTO CONVERSION     FM TO @FM, SM TO @SM,TNO TO C$T24.SESSION.NO
*25-05-2023    VICTORIA S          R22 MANUAL CONVERSION   Call routine modified
*-----------------------------------------------------------------------------
    GOSUB MAIN
    GOSUB INTIALISE
    GOSUB PROCESS
RETURN
*----------------
MAIN:
*----------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ALE = 'F.AC.LOCKED.EVENTS'
    F.ALE = ''
    CALL OPF(FN.ALE,F.ALE)

RETURN
*-----------------------
INTIALISE:
*----------------------

    APPL = 'ACCOUNT':@FM:'AC.LOCKED.EVENTS' ;*R22 AUTO CONVERSION
    F.FIELDS = 'L.AC.STATUS2':@FM:'L.AC.STATUS2' ;*R22 AUTO CONVERSION
    CALL MULTI.GET.LOC.REF(APPL,F.FIELDS,LOC.POS)
    Y.ST.PS = LOC.POS<1,1>
    Y.ACL.PS = LOC.POS<2,1>
RETURN
*--------------------------------
INPUT.PROCESS:
*--------------------------------
    Y.AC.STATU2 = CHANGE(R.ACCOUNT<AC.LOCAL.REF,Y.ST.PS>,@SM,@FM) ;*R22 AUTO CONVERSION
    Y.COUNT.STATUS2 = DCOUNT(Y.AC.STATU2,@FM) ;*R22 AUTO CONVERSION
    Y.LOCK.STATUS = R.NEW(AC.LCK.LOCAL.REF)<1,Y.ACL.PS>

****LOC TABLE UPDATE***
*CALL REDO.UPD.ACCOUNT.STATUS.DATE(Y.AC.NO,Y.LOCK.STATUS)
    CALL APAP.REDOAPAP.redoUpdAccountStatusDate(Y.AC.NO,Y.LOCK.STATUS);*R22 MANUAL CONVERSION
****END****
    LOCATE Y.LOCK.STATUS IN Y.AC.STATU2 SETTING STAT.POS ELSE
        R.ACCOUNT<AC.LOCAL.REF,Y.ST.PS,-1> = R.NEW(AC.LCK.LOCAL.REF)<1,Y.ACL.PS>
    END
    R.ACCOUNT<AC.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CONVERSION
    TEMPTIME = OCONV(TIME(),"MTS")
    TEMPTIME = TEMPTIME[1,5]
    CHANGE ':' TO '' IN TEMPTIME
    CHECK.DATE = DATE()
    R.ACCOUNT<AC.DATE.TIME> = OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):OCONV(CHECK.DATE,"DD"):TEMPTIME
* R.ACCOUNT<AC.CO.CODE> = ID.COMPANY
    R.ACCOUNT<AC.AUTHORISER> =C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CONVERSION
* R.ACCOUNT<AC.DEPT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    CALL F.WRITE(FN.ACCOUNT,Y.AC.NO,R.ACCOUNT)
RETURN
*-----------------
REVERSE.PROCESS:
*-----------------
    IF NO.OF.RECS EQ 1 THEN
        R.ACCOUNT<AC.LOCAL.REF,Y.ST.PS> = ''
        R.ACCOUNT<AC.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CONVERSION
        TEMPTIME = OCONV(TIME(),"MTS")
        TEMPTIME = TEMPTIME[1,5]
        CHANGE ':' TO '' IN TEMPTIME
        CHECK.DATE = DATE()
        R.ACCOUNT<AC.DATE.TIME> = OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):OCONV(CHECK.DATE,"DD"):TEMPTIME
* R.ACCOUNT<AC.CO.CODE> = ID.COMPANY
        R.ACCOUNT<AC.AUTHORISER> =C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CONVERSION
* R.ACCOUNT<AC.DEPT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
        CALL F.WRITE(FN.ACCOUNT,Y.AC.NO,R.ACCOUNT)
***LOC TABLE UPDATE***
*CALL REDO.UPD.ACCOUNT.STATUS.DATE( Y.AC.NO,Y.LOCK.STATUS)
        CALL APAP.REDOAPAP.redoUpdAccountStatusDate(Y.AC.NO,Y.LOCK.STATUS) ;*R22 MANUAL CONVERSION
****END****

    END ELSE
        RETURN
    END
RETURN
*-----------------------------------------------------
PROCESS:
*-----------------------------------------------------
    Y.AC.NO = R.NEW(AC.LCK.ACCOUNT.NUMBER)
    IF Y.AC.NO THEN
        CALL F.READ(FN.ACCOUNT,Y.AC.NO,R.ACCOUNT,F.ACCOUNT,AC.ERR)
        Y.CK = V$FUNCTION
        IF V$FUNCTION EQ 'I' THEN
            IF R.ACCOUNT THEN
                GOSUB INPUT.PROCESS
            END
        END
        IF V$FUNCTION EQ 'R' THEN
            IF R.ACCOUNT THEN
                SEL.CMD = 'SELECT ':FN.ALE:' WITH ACCOUNT.NUMBER EQ ':Y.AC.NO
                CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,SEL.ERR)
                GOSUB REVERSE.PROCESS
            END
        END
    END

RETURN
*----------
PGM.END:
*---------

END
