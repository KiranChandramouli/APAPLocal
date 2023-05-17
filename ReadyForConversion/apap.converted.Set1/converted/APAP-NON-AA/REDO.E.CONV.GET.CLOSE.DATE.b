SUBROUTINE REDO.E.CONV.GET.CLOSE.DATE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CONV.GET.CLOSE.DATE
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the CLOSURE.DATE
*                    from ACCOUNT and returns it to O.DATA
*Linked With       : Enquiry REDO.APAP.ENQ.S.ACCT.DYN.RPT
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*--------------------------------------------------------------------------------------------------------
*Date                   Who                  Reference                        Description
*------                 -----                -------------                    -------------
* 15.11.2010     Sakthi Sellappillai         ODR-2010-08-0173                 Initial Creation
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.USER

    GOSUB PROCESS.PARA
    GOSUB GOEND
RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS.PARA:
*--------------------------------------------------------------------------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    R.ACCOUNT.REC = ''
    Y.ACCT.ERR = ''
    FN.ACCOUNT$HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT$HIS = ''
    CALL OPF(FN.ACCOUNT$HIS,F.ACCOUNT$HIS)
    R.ACCOUNT.HIS.REC = ''
    Y.ACCOUNT.HIS.ERR = ''
    Y.ACCT.ID.VAL = O.DATA
    O.DATA = ''
    Y.AC.STAT.VALUE = ''
    Y.AC.STATUS1.VAL = ''
    Y.AC.CLOSE.DATE.VAL = ''
    Y.AC.STATUS2.VAL = ''
    Y.CLOSE.STRING = ''
    APPL.ARRAY           = "ACCOUNT"
    FLD.ARRAY            = "L.AC.STATUS1":@VM:"L.AC.STATUS2"
    FLD.POS              = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    L.AC.STAT1.POS = FLD.POS<1,1>
    L.AC.STAT2.POS = FLD.POS<1,2>
    Y.HIS.ACCT.ID = ''
    Y.HIS.SYM.VAL = FIELD(Y.ACCT.ID.VAL,';',2,1)
    IF Y.HIS.SYM.VAL THEN
        Y.HIS.ACCT.ID = FIELD(Y.ACCT.ID.VAL,';',1,1)
        CALL EB.READ.HISTORY.REC(F.ACCOUNT$HIS,Y.HIS.ACCT.ID,R.ACCOUNT.HIS.REC,Y.ACCOUNT.HIS.ERR)
        IF NOT(Y.ACCOUNT.HIS.ERR) THEN
            Y.AC.CLOSE.DATE.VAL = R.ACCOUNT.HIS.REC<AC.CLOSURE.DATE>
        END
    END ELSE
        CALL F.READ(FN.ACCOUNT,Y.ACCT.ID.VAL,R.ACCOUNT.REC,F.ACCOUNT,Y.ACCT.ERR)
        IF NOT(Y.ACCT.ERR) THEN
            Y.AC.CLOSE.DATE.VAL = R.ACCOUNT.REC<AC.CLOSURE.DATE>
        END
    END
    IF Y.AC.CLOSE.DATE.VAL THEN
        Y.CLOSE.STRING  = 'CLOSED'
    END ELSE

        IF R.ACCOUNT.HIS.REC THEN
            Y.AC.STATUS1.VAL = R.ACCOUNT.HIS.REC<AC.LOCAL.REF,L.AC.STAT1.POS>
            LOOKUP.ID = 'L.AC.STATUS1'
            Y.VALUE = Y.AC.STATUS1.VAL
            GOSUB RETRIEVE.SPANISH.DESC
            Y.AC.STATUS1.VAL = Y.VALUE

            LOOKUP.ID = 'L.AC.STATUS2'
            Y.AC.STATUS2.VAL = R.ACCOUNT.HIS.REC<AC.LOCAL.REF,L.AC.STAT2.POS>
            Y.VALUE = Y.AC.STATUS2.VAL
            GOSUB RETRIEVE.SPANISH.DESC
            Y.AC.STATUS2.VAL = Y.VALUE
            IF Y.AC.STATUS2.VAL THEN
                Y.AC.STAT.VALUE = Y.AC.STATUS1.VAL:';':Y.AC.STATUS2.VAL
            END
            ELSE
                Y.AC.STAT.VALUE = Y.AC.STATUS1.VAL
            END
        END ELSE
            Y.AC.STATUS1.VAL = R.ACCOUNT.REC<AC.LOCAL.REF,L.AC.STAT1.POS>
            LOOKUP.ID = 'L.AC.STATUS1'
            Y.VALUE = Y.AC.STATUS1.VAL
            GOSUB RETRIEVE.SPANISH.DESC
            Y.AC.STATUS1.VAL = Y.VALUE

            LOOKUP.ID = 'L.AC.STATUS2'
            Y.AC.STATUS2.VAL = R.ACCOUNT.REC<AC.LOCAL.REF,L.AC.STAT2.POS>
            Y.VALUE = Y.AC.STATUS2.VAL
            GOSUB RETRIEVE.SPANISH.DESC
            Y.AC.STATUS2.VAL = Y.VALUE
            IF Y.AC.STATUS2.VAL THEN
                Y.AC.STAT.VALUE = Y.AC.STATUS1.VAL:';':Y.AC.STATUS2.VAL
            END
            ELSE
                Y.AC.STAT.VALUE = Y.AC.STATUS1.VAL
            END
        END
    END
    IF NOT(Y.CLOSE.STRING) THEN
        IF Y.AC.STAT.VALUE THEN
            O.DATA = Y.AC.STAT.VALUE
        END ELSE
            O.DATA = ''
        END
    END ELSE
        O.DATA = Y.CLOSE.STRING
    END
RETURN

*--------------------------------------------------------------------------------------------------------
RETRIEVE.SPANISH.DESC:
    VIRTUAL.TAB.ID=LOOKUP.ID
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
    Y.LOOKUP.LIST=VIRTUAL.TAB.ID<2>
    Y.LOOKUP.DESC=VIRTUAL.TAB.ID<11>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC
    Y.VAL.SEQ = 1
    Y.VAL.CNT = DCOUNT(Y.VALUE,@SM)
    LOOP
    WHILE Y.VAL.SEQ LE Y.VAL.CNT
        LOCATE Y.VALUE<1,1,Y.VAL.SEQ> IN Y.LOOKUP.LIST SETTING POS1 THEN
            IF R.USER<EB.USE.LANGUAGE> EQ 1 THEN        ;* This is for english user
                Y.VALUE<1,1,Y.VAL.SEQ>=Y.LOOKUP.DESC<POS1,1>
            END
            IF R.USER<EB.USE.LANGUAGE> EQ 2 AND Y.LOOKUP.DESC<POS1,2> NE '' THEN
                Y.VALUE<1,1,Y.VAL.SEQ>=Y.LOOKUP.DESC<POS1,2>        ;* This is for spanish user
*END ELSE
*Y.VALUE<1,1,Y.VAL.SEQ>=Y.LOOKUP.DESC<POS1,1>
            END
        END
        Y.VAL.SEQ += 1

    REPEAT
    CHANGE @SM TO ';' IN Y.VALUE

RETURN

*--------------------------------------------------------------------------------------------------------
GOEND:
RETURN
*--------------------------------------------------------------------------------------------------------
END
*-------------------------------------------*END OF SUBROUTINE*------------------------------------------
