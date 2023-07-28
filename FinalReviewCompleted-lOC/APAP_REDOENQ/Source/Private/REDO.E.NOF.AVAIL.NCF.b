$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.NOF.AVAIL.NCF(Y.ARRAY)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion  - F.READ to CACHE.READ , I to I.VAR and FM to @FM
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER

    GOSUB INIT
    GOSUB PROCESS

RETURN

INIT:
*---
    FN.REDO.AA.NCF.IDS = 'F.REDO.AA.NCF.IDS'
    F.REDO.AA.NCF.IDS = ''
    CALL OPF(FN.REDO.AA.NCF.IDS, F.REDO.AA.NCF.IDS)

    FN.USER = 'F.USER'
    F.USER = ''
    CALL OPF(FN.USER, F.USER)

    Y.USER.ID = ''
    Y.BRANCH = ''
    LOCATE 'USER.ID' IN D.FIELDS<1> SETTING Y.USER.POS THEN
        Y.USER.ID = D.RANGE.AND.VALUE<Y.USER.POS>
        Y.U.EQ = D.LOGICAL.OPERANDS<Y.USER.POS>
        COMMON.OP = Y.U.EQ
        GOSUB OPERAND.VALUES
        Y.U.EQ = COMMON.OP
    END

    LOCATE 'BRANCH' IN D.FIELDS<1> SETTING Y.BRAN.POS THEN
        Y.BRANCH = D.RANGE.AND.VALUE<Y.BRAN.POS>
        Y.EQ = D.LOGICAL.OPERANDS<Y.BRAN.POS>
        COMMON.OP = Y.EQ
        GOSUB OPERAND.VALUES
        Y.EQ =COMMON.OP
    END

RETURN

OPERAND.VALUES:
*--------------
    IF COMMON.OP NE '' THEN
        BEGIN CASE
            CASE COMMON.OP EQ 1
                COMMON.OP = 'EQ'
            CASE COMMON.OP EQ 2
                COMMON.OP = 'RG'
            CASE COMMON.OP EQ 3
                COMMON.OP = 'LT'
            CASE COMMON.OP EQ 4
                COMMON.OP = 'GT'
            CASE COMMON.OP EQ 5
                COMMON.OP = 'NE'
            CASE COMMON.OP EQ 6
                COMMON.OP = 'LIKE'
            CASE COMMON.OP EQ 7
                COMMON.OP = 'UL'
            CASE COMMON.OP EQ 8
                COMMON.OP = 'LE'
            CASE COMMON.OP EQ 9
                COMMON.OP = 'GE'
            CASE COMMON.OP EQ 10
                COMMON.OP = 'NR'
        END CASE
    END
RETURN

PROCESS:
*-------

    SEL.CMD = 'SELECT ':FN.REDO.AA.NCF.IDS:' WITH (@ID UNLIKE FT...)'

    IF Y.USER.ID THEN
        SEL.CMD :=' AND (@ID ':Y.U.EQ:' ':Y.USER.ID:')'
    END

    IF Y.BRANCH NE '' AND Y.USER.ID EQ '' THEN
        Y.USER.CMD = 'SELECT ':FN.USER:' WITH COMPANY.CODE ':Y.EQ:' "':Y.BRANCH:'"'
        CALL EB.READLIST(Y.USER.CMD, Y.SEL.LIST,'',NO.OF.REC, ERR)
        CHANGE @FM TO '" "' IN Y.SEL.LIST
        Y.SEL.LIST='"':Y.SEL.LIST:'"'
        SEL.CMD = 'SELECT ':FN.REDO.AA.NCF.IDS:' WITH @ID EQ ':Y.SEL.LIST
    END

    CALL EB.READLIST(SEL.CMD, SEL.LIST,'',NOR,RECT.CODE)

    I.VAR = 1
    LOOP
    WHILE I.VAR LE NOR
        Y.ID = SEL.LIST<I.VAR>
        CALL F.READ(FN.REDO.AA.NCF.IDS, Y.ID, R.REDO.AA.NCF.IDS, F.REDO.AA.NCF.IDS, Y.NCF.ERR)
        Y.AVAIL.COUNT = DCOUNT(R.REDO.AA.NCF.IDS,@FM)
        Y.USER.ID = Y.ID
        CALL CACHE.READ(FN.USER, Y.ID, R.USER1, Y.USER.ERR)    ;*R22 Auto Conversion  - F.READ to CACHE.READ
        Y.BRANCH = R.USER1<EB.USE.COMPANY.CODE>
        CHANGE ' ' TO @VM IN Y.BRANCH
        Y.ARRAY<-1> = Y.USER.ID:'*':Y.AVAIL.COUNT:'*':Y.BRANCH
        I.VAR += 1
    REPEAT

RETURN
END
