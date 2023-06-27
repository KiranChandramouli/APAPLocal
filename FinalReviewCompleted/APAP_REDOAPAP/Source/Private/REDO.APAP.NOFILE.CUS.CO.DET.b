* @ValidationCode : MjoyMTExMTA2NjAzOkNwMTI1MjoxNjg0ODM2MDUwNzk1OklUU1M6LTE6LTE6MjUzNjoxOmZhbHNlOk4vQTpSMjJfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 2536
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOFILE.CUS.CO.DET(Y.ARRAY)
*------------------------------------------------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.APAP.NOFILE.CUS.CO.DET
*Date              : 31.05.2010
*-----------------------------------------------------------------------------------------------------------------
* Description : This routine is a nofile routine attached to the STANDARD.SELECTION record NOFILE.REDO.ENQ.CUS.CO.DETS
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  : --N/A--
* Out : Y.ARRAY
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Date              Name              Reference               Version
* -------           ----              ----------              --------
* 31/05/2010      Rashmitha M       ODR-2009-10-0310        Initial Version

*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*17-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM , SM ton @SM
*17-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ENQUIRY
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.COLLATERAL
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.LIMIT
    $INSERT I_F.LIMIT
    $INSERT I_F.REDO.CUS.SEC.FOL.NO.DET
    $INSERT I_F.REDO.CUS.PORTFOLIO.DET
    $INSERT I_F.AA.OFFICERS
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER.ACCOUNT
*   $INSERT I_F.AA.TERM.AMOUNT


    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*------------------------------------------------------------------------------------------------------------------
**********
INITIALISE:
**********
    FN.CUSTOMER='F.CUSTOMER'                                  ;     F.CUSTOMER=''
    FN.COLLATERAL='F.COLLATERAL'                              ;     F.COLLATERAL=''
    FN.LIMIT='F.LIMIT'                                        ;     F.LIMIT=''
    FN.REDO.CUS.SEC.FOL.NO.DET='F.REDO.CUS.SEC.FOL.NO.DET'    ;     F.REDO.CUS.SEC.FOL.NO.DET=''
    FN.REDO.CUS.PORTFOLIO.DET ='F.REDO.CUS.PORTFOLIO.DET'     ;     F.REDO.CUS.PORTFOLIO.DET=''
    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'                      ;     F.AA.ARRANGEMENT=''
    FN.ACCOUNT='F.ACCOUNT'                                    ;     F.ACCOUNT=''
    FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'                  ;     F.CUSTOMER.ACCOUNT=''
    FN.AA.ARR.TERM.AMOUNT='F.AA.ARR.TERM.AMOUNT'              ;     F.AA.ARR.TERM.AMOUNT=''
    FN.CUSTOMER.COLLATERAL = 'F.CUSTOMER.COLLATERAL'          ;     F.CUSTOMER.COLLATERAL = ''
    Y.MNE=''             ;      R.ARR = ''
    Y.CUS.NAME=''
    Y.CO.ID=''           ;      Y.CO.TYPE=''            ;          Y.LOAN.IDS=''        ;         Y.FLD.OP=''
    Y.ALT.ID='@'         ;      Y.LOAN.ID=''            ;          Y.LOAN.NAME='@'      ;         Y.LOAN.STATUS='@'
    Y.AMOUNT='@'         ;      Y.LIMIT.ID='@'          ;          Y.LIMIT.AMT='@'      ;         Y.POL.TYPE='@'
    Y.SEC.FOLD.NO=''     ;      Y.PORTF.NO=''           ;          Y.OFFICER='@'        ;         Y.PDT.TYPE='@'
    POS.LN.STATUS=''     ;      POS.POL.TYPE=''         ;          POS.LN.STATUS=''     ;         POS.LN.COND=''
    Y.CO.IDS = '@'       ;      Y.LOAN.IDSS = '@'       ;          Y.CO.TYPES = '@'     ;         Y.ERR.FLAG=''

    APPL.ARRAY = 'AA.ARR.TERM.AMOUNT'
    FLD.ARRAY  = 'L.AA.COL'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.AA.COL        = FLD.POS<1,1>

RETURN
*------------------------------------------------------------------------------------------------------------------
*********
OPENFILES:
*********
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
    CALL OPF(FN.CUSTOMER.COLLATERAL,F.CUSTOMER.COLLATERAL)
    CALL OPF(FN.LIMIT,F.LIMIT)
    CALL OPF(FN.REDO.CUS.SEC.FOL.NO.DET,F.REDO.CUS.SEC.FOL.NO.DET)
    CALL OPF(FN.REDO.CUS.PORTFOLIO.DET,F.REDO.CUS.PORTFOLIO.DET)
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)

RETURN
*-------------------------------------------------------------------------------------------------------------------
*******
PROCESS:
*******

    Y.CUS.ID.LIST = ''
    Y.NULL.VALUE = ''
    LOCATE 'CUSTOMER.ID' IN D.FIELDS<1> SETTING Y.POS1 THEN
        Y.CUS.ID.LIST=D.RANGE.AND.VALUE<Y.POS1>
        Y.NULL.VALUE = '1'
    END ELSE
        SEL.CMD.CUS.COL ='SELECT ':FN.CUSTOMER.COLLATERAL
        CALL EB.READLIST(SEL.CMD.CUS.COL,SEL.CMD.CUS.LIST,'',NO.OF.RECS.MNE,SEL.ERR.MNE)
        Y.CUS.ID.LIST<-1> = SEL.CMD.CUS.LIST
    END

    LOCATE 'COLLATERAL.ID' IN D.FIELDS<1> SETTING Y.POS.CAL THEN
        Y.COLL.VAL=D.RANGE.AND.VALUE<Y.POS.CAL>
        IF NOT(Y.NULL.VALUE) THEN
            Y.CUS.ID.LIST = FIELD(Y.COLL.VAL,".",1)
        END
    END

    LOOP
        REMOVE Y.CUS.ID FROM Y.CUS.ID.LIST SETTING POS.CUS.COL
    WHILE Y.CUS.ID:POS.CUS.COL

        Y.ARR.FLAG = '' ; Y.COL.FLAG = '' ; Y.MN.FALG = '' ; Y.CUS.FALG = ''

        Y.ALT.ID='@'         ;       Y.LOAN.NAME='@'        ;         Y.LOAN.STATUS='@'  ; Y.POL.TYPE='@' ; Y.CO.TYPE = ''
        Y.AMOUNT='@'         ;      Y.LIMIT.ID='@'          ;         Y.LIMIT.AMT='@'    ; Y.POL.TYPE='@'
        Y.OFFICER='@'        ;      Y.PDT.TYPE='@'          ;         Y.CO.IDS = '@'     ; Y.LOAN.IDSS = '@'       ;   Y.CO.TYPES = '@'
        CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUS,F.CUSTOMER,Y.ERR)
        GOSUB SEL.MNEMONIC.LIST
        GOSUB SEL.CUSTOMER.NAME.LIST

        GOSUB SEL.COLLATERAL.ID.LIST

        IF NOT(Y.COL.FLAG) AND Y.ERR.FLAG NE '1' THEN
            GOSUB ACCOUNT.READ.GET.ARR.ID
        END
    REPEAT

RETURN
*--------------------------------------------------------------
SEL.MNEMONIC.LIST:
*--------------------------------------------------------------
    SEL.FLD.NAME='MNEMONIC'
    Y.SEL.FLD.NO='1'
    GOSUB GET.VALUES
    OPERAND=OPERAND.LIST<Y.FLD.OP>

* If mnemonic is entered in selection field:

    IF OPERAND EQ 'EQ' AND Y.FLD.VALUE NE '' AND Y.FLD.VALUE NE R.CUS<EB.CUS.MNEMONIC> THEN
        Y.MN.FALG = '1'
    END

* If operand is Equals

    IF OPERAND EQ 'EQ' AND Y.SEL.FLD.NO EQ '1' AND NOT(Y.MN.FALG) THEN
        Y.MNE=Y.FLD.VALUE
        Y.CUS.ID.LIST = ''
    END

RETURN

*-----------------------------------------------------------------
SEL.CUSTOMER.NAME.LIST:
*-----------------------------------------------------------------
    Y.LAN.CUS = ''
    SEL.FLD.NAME='CUSTOMER.NAME'
    Y.SEL.FLD.NO='2'

    GOSUB GET.VALUES
    OPERAND=OPERAND.LIST<Y.FLD.OP>
    Y.LAN.CUS = R.CUS<EB.CUS.LANGUAGE>
    Y.NAME.CUSTOMER.LIST = R.CUS<EB.CUS.NAME.1,Y.LAN.CUS>
* If customer name is  entered in selection field:
    IF OPERAND EQ 'EQ' AND Y.FLD.VALUE NE '' AND Y.FLD.VALUE NE R.CUS<EB.CUS.NAME.1,Y.LAN.CUS> THEN
        Y.CUS.FALG = '1'
    END

* If operand is Equals
    IF OPERAND EQ 'EQ' AND Y.SEL.FLD.NO EQ '2' AND NOT(Y.CUS.FALG) THEN
        Y.CUS.NAME=Y.FLD.VALUE
        Y.CUS.ID.LIST = ''
    END

RETURN
*-------------------------------------------------------------------
SEL.COLLATERAL.ID.LIST:
*-------------------------------------------------------------------
    Y.COL.SEL.VAL.ARR = ''
    SEL.FLD.NAME='COLLATERAL.ID'
    Y.SEL.FLD.NO='3'

    GOSUB GET.VALUES
    OPERAND=OPERAND.LIST<Y.FLD.OP>

* If collateral id is entered in selection field
    Y.CO.CUS=FIELD(Y.FLD.VALUE,'.',1)
    IF OPERAND EQ 'EQ' AND Y.CO.CUS NE '' AND Y.CO.CUS NE Y.CUS.ID THEN
        Y.COL.FLAG = '1'
    END

* If operand is Equals
    IF OPERAND EQ 'EQ' AND Y.SEL.FLD.NO EQ '3' AND NOT(Y.COL.FLAG) THEN
        Y.CUS.ID.LIST = ''
        Y.COL.SEL.VAL.ARR = Y.FLD.VALUE
        SEL.LIST1 = Y.FLD.VALUE
        GOSUB GET.COL.ID.AND.TYPE
        IF Y.ERR.FLAG EQ '1' THEN
            RETURN
        END
        GOSUB GET.CO.TYPE
    END

RETURN
*-------------------------------------------------------------------
ACCOUNT.CHECK:
*-------------------------------------------------------------------

    CALL F.READ(FN.ACCOUNT,Y.FLD.VALUE,R.ACCOUNT.CH,F.ACCOUNT,Y.ACCOUNT.ERR.C)
    IF R.ACCOUNT.CH THEN
        Y.FLD.VALUE = R.ACCOUNT.CH<AC.ARRANGEMENT.ID>
    END
RETURN
*-------------------------------------------------------------------
ACCOUNT.READ.GET.ARR.ID:
*--------------------------------------------------------------------

    Y.LOAD.SEL.GIVE.VAL = ''
    SEL.FLD.NAME='LOAN.ID'
    Y.SEL.FLD.NO='4'

    GOSUB GET.VALUES
    OPERAND=OPERAND.LIST<Y.FLD.OP>

* If loan id  entered in selection field

    IF OPERAND EQ 'EQ' THEN
        GOSUB ACCOUNT.CHECK
        CALL F.READ(FN.AA.ARRANGEMENT,Y.FLD.VALUE,R.ARR,F.AA.ARRANGEMENT,Y.AA.ERR)
        IF R.ARR<AA.ARR.CUSTOMER> EQ '' AND Y.FLD.VALUE THEN
            Y.ARR.FLAG = '1'
        END
    END

    IF OPERAND EQ 'EQ' AND R.ARR<AA.ARR.CUSTOMER> NE Y.CUS.ID AND  R.ARR<AA.ARR.CUSTOMER> NE '' THEN
        Y.ARR.FLAG = '1'
    END

* If operand is equals
    IF OPERAND EQ 'EQ' AND Y.SEL.FLD.NO EQ '4' AND NOT(Y.ARR.FLAG) THEN
        Y.LOAD.SEL.GIVE.VAL = Y.FLD.VALUE
        Y.LOAN.ID=Y.FLD.VALUE
        GOSUB GET.COLL.ARR
        IF Y.LOAN.IDSS EQ '@' THEN
            Y.LOAN.IDSS=Y.LOAN.ID
        END
    END

*-------------------------------------------------------------------------
    GOSUB GET.SEC.FOLD.NO

    IF NOT(Y.ARR.FLAG) AND NOT(Y.COL.FLAG) AND NOT(Y.MN.FALG) AND NOT(Y.CUS.FALG) AND SEL.LIST1 AND NOT(Y.COL.ARRAY.CNT.CHECK.FLAG) THEN

        GOSUB OUTGOING.ARRAY
    END

RETURN
*-------------------------------------------------------------------------

**********
GET.VALUES:
**********

    Y.FLD.VALUE=''
    Y.POS=''
    LOCATE SEL.FLD.NAME IN D.FIELDS<1> SETTING Y.POS THEN
        Y.FLD.VALUE=D.RANGE.AND.VALUE<Y.POS>
        Y.FLD.OP=D.LOGICAL.OPERANDS<Y.POS>
    END ELSE
        Y.FLAG=Y.SEL.FLD.NO
        GOSUB SEL.VALUE.NULL
        Y.SEL.FLD.NO=''
    END

RETURN

*---------------------------------------------------------------------------------------------------------------------------------------------
*************
SEL.VALUE.NULL:
*************
*If no value is given in selection field for respective fields:
    BEGIN CASE
        CASE Y.FLAG EQ '1'
            Y.MNE=R.CUS<EB.CUS.MNEMONIC>

        CASE Y.FLAG EQ '2'
            Y.CUS.NAME= R.CUS<EB.CUS.NAME.1>

        CASE Y.FLAG EQ '3'

            SEL.CMD1="SELECT ":FN.COLLATERAL:" WITH @ID LIKE ":Y.CUS.ID:"..."
            CALL EB.READLIST(SEL.CMD1,SEL.LIST1,'',NO.OF.RECS1,SEL.ERR1)
            Y.CO.ID=SEL.LIST1
            LOOP
                REMOVE Y.ID FROM SEL.LIST1 SETTING Y.CO.POS1
            WHILE Y.ID:Y.CO.POS1
                CALL F.READ(FN.COLLATERAL,Y.ID,R.COL,F.COLLATERAL,Y.COL.ERR)
                GOSUB GET.CO.TYPE
            REPEAT


        CASE Y.FLAG EQ '4'
            CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.CUS.ID,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,Y.CUS.ACC.ERR)
            Y.ACCOUNTS=''
            Y.ACCOUNTS=R.CUSTOMER.ACCOUNT

            GOSUB GET.LOAN.ID

    END CASE
RETURN
*------------------------------------------------------------------------------------------------------------------------------------------
********************
GET.COL.ID.AND.TYPE:
********************
    Y.ID=Y.FLD.VALUE
    CALL F.READ(FN.COLLATERAL,Y.ID,R.COL,F.COLLATERAL,Y.COL.ERR)
    IF R.COL EQ '' THEN
        ENQ.ERROR="Collateral record doesnot exist"
        Y.ERR.FLAG='1'
        RETURN
    END
    IF Y.CO.ID EQ '' THEN
        Y.CO.ID=Y.FLD.VALUE
    END ELSE
        Y.CO.ID:=@FM:Y.FLD.VALUE
    END
    IF NOT(Y.CO.ID) THEN
        ENQ.ERROR="No collateral records for this customer"
        Y.ERR.FLAG='1'
        RETURN
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------------------------------
***********
GET.CO.TYPE:
***********

    IF Y.CO.TYPE EQ '' THEN
        Y.CO.TYPE=R.COL<COLL.COLLATERAL.TYPE>
        RETURN
    END
    Y.CO.TYPE:=@VM:R.COL<COLL.COLLATERAL.TYPE>
RETURN
*-------------------------------------------------------------------------------------------------------------------------------------------
************
GET.LOAN.ID:
************
    Y.STATUS = '' ; Y.STATUS.FLAG.AA = ''
    IF Y.ACCOUNTS EQ '' THEN
        GOSUB GET.DETAILS.NULL
        RETURN
    END
    LOOP
        REMOVE Y.ACC.ID FROM Y.ACCOUNTS SETTING Y.AC.POS
    WHILE Y.ACC.ID:Y.AC.POS
        CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,Y.ACCOUNT.ERR)
        IF R.ACCOUNT<AC.ARRANGEMENT.ID> EQ '' THEN
            CONTINUE
        END
        Y.LOAN.ID= R.ACCOUNT<AC.ARRANGEMENT.ID>
        CALL F.READ(FN.AA.ARRANGEMENT,Y.LOAN.ID,R.ARR.NEW,F.AA.ARRANGEMENT,Y.AA.ERR)
        Y.STATUS = R.ARR.NEW<AA.ARR.ARR.STATUS>
        IF Y.STATUS NE 'UNAUTH' THEN
            GOSUB GET.COLL.ARR
        END
    REPEAT
RETURN
*-------------------------------------------------------------------------------------------------------------------------------------
*************
GET.COLL.ARR:
*************

    idPropertyClass = "TERM.AMOUNT"
    GOSUB GET.ARR.CONDITION
    IF R.CONDITION THEN
        GOSUB GET.ARR.CONDITION.DETAILS
    END
RETURN
*-------------------------------------------------------------------------------
GET.ARR.CONDITION:
*-------------------------------------------------------------------------------

    ArrangementID = Y.LOAN.ID ; returnError      = ''
    idProperty    = ''          ; effectiveDate    = ''
    returnIds     = ''          ; returnConditions = ''
    R.CONDITION   = ''

    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.CONDITION = RAISE(returnConditions)
RETURN

*-------------------------------------------------------------------------------
GET.ARR.CONDITION.DETAILS:
*-------------------------------------------------------------------------------
    Y.COL.ARRAY.CNT.CHECK.FLAG = ''
    Y.COL.COUNT = DCOUNT(Y.CO.ID,@FM)
    Y.COL = 1
    Y.COL.NO.ARR=''
    Y.COL.TYPE.NO.ARR=''
    Y.COL.ARRAY.CNT.CHECK = 1
    LOOP
    WHILE Y.COL LE Y.COL.COUNT

        LOCATE Y.CO.ID<Y.COL> IN R.CONDITION<AA.AMT.LOCAL.REF,LOC.L.AA.COL,1> SETTING L.AA.COL.POS THEN
            IF Y.CO.IDS EQ '@' THEN
                Y.CO.IDS = Y.CO.ID<Y.COL>
                Y.CO.ID.NEW = Y.CO.ID<Y.COL>
            END ELSE
                Y.CO.IDS :=@VM:Y.CO.ID<Y.COL>
                Y.CO.ID.NEW := @VM:Y.CO.ID<Y.COL>
            END

            IF Y.LOAN.IDSS EQ '@' THEN
                Y.LOAN.IDSS = Y.LOAN.ID
            END ELSE
                Y.LOAN.IDSS := @VM:Y.LOAN.ID
            END

            IF Y.CO.TYPES EQ '@' THEN
                Y.CO.TYPES = FIELD(Y.CO.TYPE,@VM,Y.COL)
            END ELSE
                Y.CO.TYPES:= @VM:FIELD(Y.CO.TYPE,@VM,Y.COL)
            END
            GOSUB GET.DETAILS
        END ELSE
            IF Y.COL.SEL.VAL.ARR AND Y.LOAD.SEL.GIVE.VAL THEN
                Y.COL.ARRAY.CNT.CHECK.FLAG = '1'
            END
        END
        Y.COL += 1
    REPEAT
    CHANGE @FM TO @VM IN Y.LOAN.IDSS
RETURN
*-------------------------------------------------------------------------------------------------------------------------------------
*****************
GET.DETAILS.NULL:
*****************
    Y.ALT.ID=''   ;   Y.LOAN.ID=''   ;    Y.LOAN.STATUS=''  ;   Y.AMOUNT=''    ;    Y.LIMIT.ID=''
    Y.OFFICER=''  ;   Y.PDT.TYPE=''  ;    Y.LOAN.NAME=''    ;   Y.POL.TYPE=''  ;    Y.LIMIT.AMT=''

RETURN
*------------------------------------------------------------------------------------------------------------------------------------
**************
GET.SEC.FOLD.NO:
*************
* Get security folder number
    CALL F.READ(FN.REDO.CUS.SEC.FOL.NO.DET,Y.CUS.ID,R.SEC.FOLD,F.REDO.CUS.SEC.FOL.NO.DET,Y.ERR)
    IF R.SEC.FOLD NE '' THEN
        Y.SEC.FOLD.NO=R.SEC.FOLD<CUS.SEC.SEC.FOLD.NO>
    END
RETURN
*-------------------------------------------------------------------------------------------------------------------------------------------
************
GET.DETAILS:
************

*APAP.REDOAPAP.REDO.APAP.NOFILE.CUS.CO.DET.GET.DET(Y.LOAN.ID,Y.ALT.ID,Y.LOAN.STATUS,Y.AMOUNT,Y.LIMIT.ID,Y.LIMIT.AMT,Y.OFFICER,Y.PDT.TYPE,Y.LOAN.NAME,Y.POL.TYPE,Y.CUS.ID,Y.PORTF.NO)
    APAP.REDOAPAP.redoApapNofileCusCoDetGetDet(Y.LOAN.ID,Y.ALT.ID,Y.LOAN.STATUS,Y.AMOUNT,Y.LIMIT.ID,Y.LIMIT.AMT,Y.OFFICER,Y.PDT.TYPE,Y.LOAN.NAME,Y.POL.TYPE,Y.CUS.ID,Y.PORTF.NO)
RETURN
*-------------------------------------------------------------------------------------------------------------------------------------------
***************
OUTGOING.ARRAY:
***************

    IF NOT(Y.LOAD.SEL.GIVE.VAL) THEN
*        GOSUB COLL.CAL.ALL.CUS
    END

    CHANGE @FM TO @VM IN Y.CO.IDS
    CHANGE '@' TO '' IN Y.LOAN.IDSS
    CHANGE '@' TO '' IN Y.ALT.ID
    CHANGE '@' TO '' IN Y.LOAN.NAME
    CHANGE '@' TO '' IN Y.LOAN.STATUS
    CHANGE '@' TO '' IN Y.POL.TYPE
    CHANGE '@' TO '' IN Y.AMOUNT
    CHANGE '@' TO '' IN Y.LIMIT.ID
    CHANGE '@' TO '' IN Y.LIMIT.AMT
    CHANGE '@' TO '' IN Y.OFFICER
    CHANGE '@' TO '' IN Y.CO.IDS
    CHANGE '@' TO '' IN Y.CO.TYPES
    CHANGE '@' TO '' IN Y.PDT.TYPE
    IF Y.LOAN.IDSS THEN
        Y.ARRAY<-1>= Y.CUS.ID:'*':Y.MNE:'*':Y.CUS.NAME:'*':Y.CO.IDS:'*':Y.CO.TYPES:'*':Y.LOAN.IDSS:'*':Y.ALT.ID:'*':Y.LOAN.STATUS:'*':Y.AMOUNT
        Y.ARRAY   := '*':Y.LIMIT.ID:'*':Y.LIMIT.AMT:'*':Y.POL.TYPE:'*':Y.SEC.FOLD.NO:'*':Y.PORTF.NO:'*':Y.OFFICER:'*':Y.PDT.TYPE:'*':Y.LOAN.NAME
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
COLL.CAL.ALL.CUS:
*-----------------------------------------------------------------------------------------------------------------

    CHANGE @VM TO @FM IN Y.CO.IDS
    CHANGE @SM TO @FM IN Y.CO.IDS
    Y.COUNT.VAL.ALL.CUS = DCOUNT(SEL.LIST1,@FM)
    Y.ALL.CUS.VAL = 1
    LOOP
    WHILE Y.ALL.CUS.VAL LE Y.COUNT.VAL.ALL.CUS
        LOCATE SEL.LIST1<Y.ALL.CUS.VAL> IN Y.CO.IDS SETTING POS.ALL.CUS ELSE
            IF Y.CO.IDS EQ '@' THEN
                Y.CO.IDS = SEL.LIST1<Y.ALL.CUS.VAL>
                Y.CO.TYPES = FIELD(Y.CO.TYPE,@VM,Y.ALL.CUS.VAL)
            END ELSE
                Y.CO.IDS := @FM:SEL.LIST1<Y.ALL.CUS.VAL>
                Y.CO.TYPES := @VM:FIELD(Y.CO.TYPE,@VM,Y.ALL.CUS.VAL)
            END
        END
        Y.ALL.CUS.VAL += 1
    REPEAT
RETURN
*===========================================================================================================================================
END
