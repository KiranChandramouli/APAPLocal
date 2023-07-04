$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.NOF.REQUEST.SUPPLY(TX.ARRAY)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.NOF.REQUEST.SUPPLY
*--------------------------------------------------------------------------------------------------------
*Description  : This is a no file enquiry routine for the enquiry REDO.CARD.SUPPLY
*Linked With  : Enquiry REDO.CARD.SUPPLY
*In Parameter : N/A
*Out Parameter: TX.ARRAY
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------                -------------            -------------
* 10th Aug 2010    SWAMINATHAN.S.R        ODR-2010-03-0400        Initial Creation
* 28 Sep 2011      Balagurunathan         PACS00131231            Bulk renewal process
* 12-APRIL-2023      Conversion Tool       R22 Auto Conversion - FM to @FM , SM to @SM and VM to @VM , F.READ to CACHE.READ
* 12-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER
    $INSERT I_F.COMPANY
    $INSERT I_F.REDO.CARD.REQUEST
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB OPEN.PARA
    GOSUB SEL.PROC
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********

    FN.REDO.CARD.REQUEST = 'F.REDO.CARD.REQUEST'
    F.REDO.CARD.REQUEST = ''
    R.REDO.CARD.REQUEST = ''
    REDO.CARD.REQUEST.ERR = ''
    CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)

    FN.USER = 'F.USER'
    F.USER = ''
    CALL OPF(FN.USER,F.USER)

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

RETURN
*--------------------------------------------------------------------------------------------------------
SEL.PROC:
***********

    LOCATE "AGENCY" IN D.FIELDS<1> SETTING Y.AGENCY.POS THEN
        Y.AGENCY.VAL           = D.RANGE.AND.VALUE<Y.AGENCY.POS>
        CHANGE @SM TO ' ' IN Y.AGENCY.VAL
    END

    LOCATE "DATE" IN D.FIELDS<1> SETTING Y.DATE.POS  THEN
        Y.DATE.VAL         = D.RANGE.AND.VALUE<Y.DATE.POS>
        Y.DATE.VAL.FROM = D.RANGE.AND.VALUE<Y.DATE.POS,1,1>
        Y.DATE.VAL.TO = D.RANGE.AND.VALUE<Y.DATE.POS,1,2>
        IF NOT(NUM(Y.DATE.VAL.FROM)) OR LEN(Y.DATE.VAL.FROM) NE '8' OR NOT(NUM(Y.DATE.VAL.TO)) OR LEN(Y.DATE.VAL.TO) NE '8' THEN
            ENQ.ERROR = 'EB-REDO.DATE.RANGE'

        END

        IF Y.DATE.VAL.FROM[5,2] GT 12 OR Y.DATE.VAL.TO[5,2] GT 12 OR Y.DATE.VAL.FROM[7,2] GT 31 OR Y.DATE.VAL.TO[7,2] GT 31 OR Y.DATE.VAL.TO GT TODAY OR Y.DATE.VAL.FROM GT TODAY OR Y.DATE.VAL.FROM GT Y.DATE.VAL.TO THEN
            ENQ.ERROR = 'EB-REDO.DATE.RANGE'

        END
    END
    GOSUB PROCESS.DATA

RETURN
*----------------------------------------------------------------------------------------------------------
PROCESS.DATA:
**************
    SEL.CMD = 'SELECT ':FN.REDO.CARD.REQUEST:' WITH STATUS EQ 2 AND WITH RENEWAL.FLAG NE "YES" '

    Y.USER.ID = OPERATOR
    CALL CACHE.READ(FN.USER, Y.USER.ID, R.USER.REC, Y.ERR.USER)	   ;*R22 Auto Conversion  - F.READ to CACHE.READ
    Y.COMPANY.CODE = R.USER.REC<EB.USE.COMPANY.CODE>
    IF Y.AGENCY.VAL NE '' THEN
        IF Y.COMPANY.CODE EQ 'ALL' THEN
            SEL.CMD :=" AND AGENCY EQ ":Y.AGENCY.VAL
        END ELSE
            LOCATE Y.AGENCY.VAL IN Y.COMPANY.CODE<1,1> SETTING Y.AGEN.COMP.POS THEN
                SEL.CMD :=" AND AGENCY EQ ":Y.AGENCY.VAL
            END ELSE
                ENQ.ERROR = 'EB-CANNOT.ACCESS.COMPANY'
            END
        END
    END ELSE
        CHANGE @VM TO ' ' IN Y.COMPANY.CODE
        IF Y.COMPANY.CODE EQ 'ALL' THEN
            SEL.CMD.COMP = "SELECT ":FN.COMPANY
            CALL EB.READLIST(SEL.CMD.COMP,SEL.CMD.LIST,'',NO.OF.REC.COMP,Y.ERR.LIST)
            CHANGE @VM TO ' ' IN SEL.CMD.LIST
            CHANGE @FM TO ' ' IN SEL.CMD.LIST
            Y.COMPANY.CODE = SEL.CMD.LIST
        END
        SEL.CMD :=" AND AGENCY EQ ":Y.COMPANY.CODE
    END

RETURN
*-----------------------------------------------------------------------------------------------------------
************
PROCESS.PARA:
************

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',COUNT.LIST,ERR)
    LOOP
        REMOVE Y.CARD.REQ.ID FROM SEL.LIST SETTING POS
    WHILE Y.CARD.REQ.ID : POS
        CALL F.READ(FN.REDO.CARD.REQUEST,Y.CARD.REQ.ID,R.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST,REDO.CARD.REQUEST.ERR)
        IF R.REDO.CARD.REQUEST THEN
            IF R.REDO.CARD.REQUEST<REDO.CARD.REQ.STATUS> NE '' THEN
                Y.CREATION.DATE = R.REDO.CARD.REQUEST<REDO.CARD.REQ.DATE>
                IF Y.DATE.VAL NE '' THEN
                    IF Y.CREATION.DATE GE Y.DATE.VAL.FROM AND Y.CREATION.DATE LE Y.DATE.VAL.TO THEN

*Y.STATUS.COUNT = DCOUNT(R.REDO.CARD.REQUEST<REDO.CARD.REQ.STATUS>,VM)
                        Y.CARD.COUNT =   DCOUNT(R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.TYPE>,@VM)

                        GOSUB STATUS.PROCESS

                        GOSUB FINAL.ARRAY
                    END
                END ELSE
*Y.STATUS.COUNT = DCOUNT(R.REDO.CARD.REQUEST<REDO.CARD.REQ.STATUS>,VM)
                    Y.CARD.COUNT =   DCOUNT(R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.TYPE>,@VM)
                    GOSUB STATUS.PROCESS

                    GOSUB FINAL.ARRAY
                END
            END
        END
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
**************
STATUS.PROCESS:
**************

    Y.INIT.COUNT = 1
    FLAG.FT = ''
    LOOP
    WHILE Y.INIT.COUNT LE Y.CARD.COUNT

        Y.DATE.FINAL                            =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.DATE>
        Y.AGENCY.FINAL                          =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.AGENCY>
        Y.STATUS.FINAL                          =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.STATUS>
        Y.AUTO.REQUEST.FLAG.FINAL               =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.AUTO.REQUEST.FLAG>
        IF FLAG.FT EQ '' THEN
            Y.CARD.TYPE.FINAL                   =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.TYPE,Y.INIT.COUNT>
            Y.BIN.FINAL                         =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.BIN,Y.INIT.COUNT>
            Y.BRANCH.ORDERQTY.FINAL             =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.BRANCH.ORDERQTY,Y.INIT.COUNT>
            Y.REGOFF.ACCEPTQT.FINAL             =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.REGOFF.ACCEPTQTY,Y.INIT.COUNT>
            Y.CARD.SERIES.ID.FINAL              =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.SERIES.ID,Y.INIT.COUNT>
            Y.CARD.START.NO.FINAL               =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.START.NO,Y.INIT.COUNT>
            Y.PERS.CARD.FINAL                   =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.PERS.CARD,Y.INIT.COUNT>
            Y.CUSTOMER.NO.FINAL                 =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.CUSTOMER.NO,Y.INIT.COUNT,1>
            Y.ACCOUNT.NO.FINAL                  =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.ACCOUNT.NO,Y.INIT.COUNT,1>
            Y.CUSTOMER.NAME.FINAL               =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.CUSTOMER.NAME,Y.INIT.COUNT,1>
            Y.COMMENTS.FINAL                    =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.COMMENTS,Y.INIT.COUNT>
            FLAG.FT = '1'
        END ELSE
            Y.CARD.TYPE.FINAL                   := @FM:R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.TYPE,Y.INIT.COUNT>
            Y.BIN.FINAL                         := @FM:R.REDO.CARD.REQUEST<REDO.CARD.REQ.BIN,Y.INIT.COUNT>
            Y.BRANCH.ORDERQTY.FINAL             := @FM:R.REDO.CARD.REQUEST<REDO.CARD.REQ.BRANCH.ORDERQTY,Y.INIT.COUNT>
            Y.REGOFF.ACCEPTQT.FINAL             := @FM:R.REDO.CARD.REQUEST<REDO.CARD.REQ.REGOFF.ACCEPTQTY,Y.INIT.COUNT>
            Y.CARD.SERIES.ID.FINAL              := @FM:R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.SERIES.ID,Y.INIT.COUNT>
            Y.CARD.START.NO.FINAL               := @FM:R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.START.NO,Y.INIT.COUNT>
            Y.PERS.CARD.FINAL                   := @FM:R.REDO.CARD.REQUEST<REDO.CARD.REQ.PERS.CARD,Y.INIT.COUNT>
            Y.CUSTOMER.NO.FINAL                 := @FM:R.REDO.CARD.REQUEST<REDO.CARD.REQ.CUSTOMER.NO,Y.INIT.COUNT,1>
            Y.ACCOUNT.NO.FINAL                  := @FM:R.REDO.CARD.REQUEST<REDO.CARD.REQ.ACCOUNT.NO,Y.INIT.COUNT,1>
            Y.CUSTOMER.NAME.FINAL               := @FM:R.REDO.CARD.REQUEST<REDO.CARD.REQ.CUSTOMER.NAME,Y.INIT.COUNT,1>
            Y.COMMENTS.FINAL                    := @FM:R.REDO.CARD.REQUEST<REDO.CARD.REQ.COMMENTS,Y.INIT.COUNT>
        END

        Y.INIT.COUNT +=1
    REPEAT

RETURN
*-----------------------------------------------------------------------------------------------------------
**************
FINAL.ARRAY:
**************

    CHANGE @FM TO @VM IN Y.CUSTOMER.NO.FINAL
    CHANGE @FM TO @VM IN Y.ACCOUNT.NO.FINAL
    CHANGE @FM TO @VM IN Y.CUSTOMER.NAME.FINAL
    CHANGE @FM TO @VM IN Y.CARD.TYPE.FINAL
    CHANGE @FM TO @VM IN Y.BIN.FINAL
    CHANGE @FM TO @VM IN Y.BRANCH.ORDERQTY.FINAL
    CHANGE @FM TO @VM IN Y.REGOFF.ACCEPTQT.FINAL
    CHANGE @FM TO @VM IN Y.CARD.SERIES.ID.FINAL
    CHANGE @FM TO @VM IN Y.CARD.START.NO.FINAL
    CHANGE @FM TO @VM IN Y.PERS.CARD.FINAL
    CHANGE @FM TO @VM IN Y.COMMENTS.FINAL

    TX.ARRAY<-1> = Y.CARD.REQ.ID:'*':Y.AGENCY.FINAL:'*':Y.CARD.TYPE.FINAL:'*':Y.BIN.FINAL:'*':Y.BRANCH.ORDERQTY.FINAL:'*':Y.REGOFF.ACCEPTQT.FINAL:'*':Y.CARD.SERIES.ID.FINAL:'*':Y.CARD.START.NO.FINAL:'*':Y.PERS.CARD.FINAL:'*':Y.CUSTOMER.NO.FINAL:'*':Y.ACCOUNT.NO.FINAL:'*':Y.CUSTOMER.NAME.FINAL:'*':Y.COMMENTS.FINAL:'*':Y.STATUS.FINAL:'*':Y.AUTO.REQUEST.FLAG.FINAL:'*':Y.DATE.FINAL


RETURN
END
