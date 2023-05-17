*-----------------------------------------------------------------------------
* <Rating>-245</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.CREATE.ARRANGEMENT.A.LIMIT(RESULT)
*-------------------------------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com).
* Date         : 15.06.2011
* Description  : Create LIMIT through FC
*-------------------------------------------------------------------------------------------------
* Modification History:
*
* Version   Date            Who               Reference      Description
* 1.0       15.06.2011      lpazmino          CR.180         Complete Refactoring
* 2.0       12.07.2011      JP                CR.180         Review and amends
* 3.0       19.08.2011      MG                CR.180         Amends
* 4.0       06.09.2011      lpazmino          CR.180         Capture overrides
* 5.0       09.11.2011      lpazmino          CR.180         Fixes in Limit Seq. generation
*                                                            to avoid HIS errors
* 5.1       03.04.2012      jvalarezo         CR.180         for all cases REVIEW.FRECUENCY has to be the EXPIRY.DATE
*-------------------------------------------------------------------------------------------------
* Input/Output: NA/RESULT (The result of the transaction)
* Dependencies: NA
*-------------------------------------------------------------------------------------------------

* <region name="INCLUDES">

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_GTS.COMMON
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.LIMIT

    $INSERT I_RAPID.APP.DEV.COMMON

    $INSERT I_F.REDO.CREATE.ARRANGEMENT

* </region>

    GOSUB INIT
    GOSUB OPEN.FILES

    IF NOT(R.NEW(REDO.FC.ID.LIMIT)) THEN
        GOSUB PROCESS
    END ELSE
        RESULT = "OK"
        GOSUB UPDATE.AVL.BAL
    END
    RETURN
*-----------------------------------------------
UPDATE.AVL.BAL:
*-----------------------------------------------

    Y.LIMIT.REF = R.NEW(REDO.FC.ID.LIMIT)
    REF.NO = FMT(FIELD(Y.LIMIT.REF,'.',1,1),"7'0'R")
    SEQ.NO = FMT(FIELD(Y.LIMIT.REF,'.',2,1),"2'0'R")
    Y.LIMIT.ID  = R.NEW(REDO.FC.CUSTOMER):".":REF.NO:".":SEQ.NO

    CALL F.READU(FN.LIMIT,Y.LIMIT.ID,R.LIMIT,F.LIMIT,LIMIT.ERR,"")
    IF R.LIMIT EQ '' THEN
        RETURN
    END
    Y.INTERNAL.AMOUNT = R.LIMIT<LI.INTERNAL.AMOUNT>
    Y.AVL.BALANCE     = R.LIMIT<LI.LOCAL.REF,POS.L.AVL.BALANCE>
    Y.TERM.AMOUNT     = R.NEW(REDO.FC.AMOUNT)
    BEGIN CASE
    CASE Y.AVL.BALANCE EQ ''  ;*   if it is NULL then
        Y.NEW.AVL.BALANCE = Y.INTERNAL.AMOUNT - Y.TERM.AMOUNT
    CASE OTHERWISE
        Y.NEW.AVL.BALANCE = (Y.AVL.BALANCE - Y.TERM.AMOUNT)
    END CASE
    IF Y.NEW.AVL.BALANCE LT 0 THEN
        AF = REDO.FC.AMOUNT
        E  = 'EB-REDO.LIMIT.INSUFF.AVLBAL':FM:FMT(Y.AVL.BALANCE,'L2,#15')
        CALL STORE.END.ERROR
        CALL F.RELEASE(FN.LIMIT,Y.LIMIT.ID,F.LIMIT)
        RESULT = 'FAIL'
        RETURN
    END

    R.LIMIT<LI.LOCAL.REF,POS.L.AVL.BALANCE> = Y.NEW.AVL.BALANCE
    TEMP.V = V
    V      = LI.AUDIT.DATE.TIME
    CALL F.LIVE.WRITE(FN.LIMIT,Y.LIMIT.ID,R.LIMIT)
    V      = TEMP.V
    CALL F.RELEASE(FN.LIMIT,Y.LIMIT.ID,F.LIMIT)
    GOSUB UPDATE.BALANCE.PARENT
    RETURN
*------------------------------------------------
UPDATE.BALANCE.PARENT:
*------------------------------------------------
    Y.LIMIT.REF.ID = R.NEW(REDO.FC.ID.LIMIT)
    Y.LIMIT.SEQ    = Y.LIMIT.REF.ID[".",2,1]
    Y.LIMIT.ID     = Y.LIMIT.REF.ID[".",1,1]
    Y.LIMIT.ID     = Y.LIMIT.ID[1,LEN(Y.LIMIT.ID)-2]
    Y.LIMIT.ID     = FMT(Y.LIMIT.ID : "00.","8'0'R")
    Y.LIMIT.ID     = R.NEW(REDO.FC.CUSTOMER) : "." : Y.LIMIT.ID : Y.LIMIT.SEQ

    CALL F.READU(FN.LIMIT,Y.LIMIT.ID,R.LIMIT,F.LIMIT,LIMIT.ERR,"")
    IF R.LIMIT EQ '' THEN
        RETURN
    END
    Y.INTERNAL.AMOUNT = R.LIMIT<LI.INTERNAL.AMOUNT>
    Y.AVL.BALANCE     = R.LIMIT<LI.LOCAL.REF,POS.L.AVL.BALANCE>
    Y.TERM.AMOUNT     = R.NEW(REDO.FC.AMOUNT)
    BEGIN CASE
    CASE Y.AVL.BALANCE EQ ''  ;*   if it is NULL then
        Y.NEW.AVL.BALANCE = Y.INTERNAL.AMOUNT - Y.TERM.AMOUNT
    CASE OTHERWISE
        Y.NEW.AVL.BALANCE = (Y.AVL.BALANCE - Y.TERM.AMOUNT)
    END CASE
    R.LIMIT<LI.LOCAL.REF,POS.L.AVL.BALANCE> = Y.NEW.AVL.BALANCE
    TEMP.V = V
    V      = LI.AUDIT.DATE.TIME
    CALL F.LIVE.WRITE(FN.LIMIT,Y.LIMIT.ID,R.LIMIT)
    V      = TEMP.V
    CALL F.RELEASE(FN.LIMIT,Y.LIMIT.ID,F.LIMIT)


    RETURN
* <region name="INIT" description="Initialise">
INIT:
    Y.PRODUCT = ''

    Y.ERR = ''

    Y.OFS.MSG.REQ = ''
    Y.OFS.MSG.RES = ''

    Y.APPLICATION = 'LIMIT'
    Y.VER.LIMIT   = 'APAP'

    FN.LIMIT = 'F.LIMIT'
    F.LIMIT  = ''
    R.LIMIT  = ''

    FN.AA.PRD.CAT.ACCOUNT = 'F.AA.PRD.CAT.ACCOUNT'
    F.AA.PRD.CAT.ACCOUNT  = ''
    R.AA.PRD.CAT.ACCOUNT  = ''

    Y.LIMIT.CATEGORY.CODE = ''
    E = ''

    Y.OVERRIDE = ''
    OVER.POS   = ''
    POS        = ''

    LOC.REF.APPLICATION   = "LIMIT"
    LOC.REF.FIELDS        = 'L.AVL.BALANCE'
    LOC.REF.POS           = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AVL.BALANCE = LOC.REF.POS<1,1>

    RETURN
* </region>

* <region name="OPEN.FILES" description="Open Files">
OPEN.FILES:
    CALL OPF(FN.LIMIT,F.LIMIT)
    CALL OPF(FN.AA.PRD.CAT.ACCOUNT,F.AA.PRD.CAT.ACCOUNT)

    RETURN
* </region>

* <region name="PROCESS" description="Main Process">
PROCESS:
    GOSUB VALIDATE.LIMIT.DATA

    IF END.ERROR THEN
        CALL OCOMO("OMMITING PROCESSING")
        RETURN
    END

    Y.RETRY.NEXT.LIM.SEQ = '1'          ;* If the parent.limit already exists, and this is in a different currency, then try to use the next sequence
    E = ''

    LOOP
        GOSUB CREATE.LIMIT.OFS
    WHILE Y.RETRY.NEXT.LIM.SEQ EQ '1' AND E = ''
    REPEAT

    Y.LIMIT.SEQ.F    =  R.NEW(REDO.FC.ID.LIMIT)[".",2,1]
    Y.LIMIT.ID.F     =  R.NEW(REDO.FC.ID.LIMIT)[".",1,1]

    IF Y.LIMIT.SEQ.F GT 1 AND Y.LIMIT.SEQ.F LT 10 THEN
        Y.LIMIT.SEQ.F = ABS(Y.LIMIT.SEQ.F)
        Y.LIMIT.SEQ.F = SUBSTRINGS(Y.LIMIT.SEQ.F,1,1)
        Y.LIMIT.SEQ.F = FMT(Y.LIMIT.SEQ.F,"2'0'R")
    END
    R.NEW(REDO.FC.ID.LIMIT) = Y.LIMIT.ID.F : "." : Y.LIMIT.SEQ.F
    IF Y.ERR THEN
        RESULT = 'FAIL'
    END ELSE
        RESULT = 'OK'
    END
    RETURN
* </region>

* <region name="VALIDATE.LIMIT.DATA" description="Validate LIMIT fields">
VALIDATE.LIMIT.DATA:
    IF R.NEW(REDO.FC.ID.LIMIT) NE '' THEN
        CALL OCOMO("LIMIT WAS ALREADY ASSOCIATED, THEN OMMIT THIS PROCESS")
        RETURN
    END

* Get Limit Product for the given Category Code
    GOSUB GET.LIMIT.PRODUCT
    GOSUB CHECK.PROCESS

* Set Limit information
    R.NEW(REDO.FC.ID.LIMIT) = Y.PRODUCT

    RETURN
* </region>

* <region name="GET.LIMIT.PRODUCT" description="Obtain the Limit Product">
GET.LIMIT.PRODUCT:
    E = ''

* Get the Category Code from the Product
    GOSUB GET.CATEGORY.CODE
    IF Y.LIMIT.CATEGORY.CODE EQ '' THEN
        CALL OCOMO("ERROR TRYING TO GET THE CATEGORY CODE FROM THE PRODUCT")
        RETURN
    END

* Get Limit Product
    CALL REDO.CREATE.AA.R.GET.LIMIT.PRODUCT("ACCOUNT", Y.LIMIT.CATEGORY.CODE, Y.PRODUCT)

* After restoring, check if LIMIT.GET.PRODUCT found an error
    IF E NE '' THEN
        AF = REDO.FC.ID.LIMIT
        ETEXT = E
        CALL STORE.END.ERROR
        CALL OCOMO("ERROR TRYING TO GET PRODUCT.LIMIT FOR THE CURRENT CONTRACT")
        RETURN
    END

* Get the next sequence to use for creating the LIMIT
    P.CUSTOMER.ID = R.NEW(REDO.FC.CUSTOMER)
    P.LIMIT.REF = Y.PRODUCT

* JP20110712
    GOSUB GET.LIMIT.SEQ

    RETURN
* </region>

* <region name="GET.LIMIT.SEQ" description="get next sequency for LIMIT">
GET.LIMIT.SEQ:
    Y.LIMIT.ID = FMT(P.LIMIT.REF,"7'0'R")

    SEL.CMD  = 'SELECT ' :FN.LIMIT
*SEL.CMD := ' LIKE ' :P.CUSTOMER.ID:'.':Y.LIMIT.ID: '... BY-DSND @ID'
    SEL.CMD := ' LIKE ' :P.CUSTOMER.ID:'.':Y.LIMIT.ID: '...'
    SEL.LIST = ''
    NO.REC   = ''
    SEL.ERR  = ''
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '', NO.REC, SEL.ERR)
    SEL.LIST = SORT(SEL.LIST)
    IF SEL.ERR NE '' THEN
*REMOVE Y.LIMIT.ID.LAST FROM SEL.LIST SETTING POS
        Y.LIMIT.ID.LAST = SEL.LIST<NO.REC>
        YNO.SEQ = FIELD(Y.LIMIT.ID.LAST,'.',3)
        YNO.SEQ = YNO.SEQ + 1
        YNO.SEQ = FMT(YNO.SEQ,"2'0'R")
    END ELSE
        YNO.SEQ = '01'
    END

* ERROR DE LIMIT REFERENCE 2001.2 , 19062012
    IF YNO.SEQ GT 1 AND YNO.SEQ LT 10 THEN
        YNO.SEQ = ABS(YNO.SEQ)
        YNO.SEQ = SUBSTRINGS(YNO.SEQ,1,1)
        YNO.SEQ = FMT(YNO.SEQ,"2'0'R")
    END

*si el numero sec menor q 10 y mayor q 1 concatene con un 0 antes

    Y.PRODUCT = Y.PRODUCT : "." : YNO.SEQ

    RETURN
* </region>

* <region name="CREATE.LIMIT.OFS" description="Create LIMIT OFS Message">
CREATE.LIMIT.OFS:

    OFS.INFO.INPUT = ""
    OFS.INFO.INPUT<1,1> = Y.VER.LIMIT
    OFS.INFO.INPUT<1,2> = "I"
    OFS.INFO.INPUT<2,1> = "PROCESS"
    OFS.INFO.INPUT<2,6> = "0"

    Y.CUSTOMER.ID  = R.NEW(REDO.FC.CUSTOMER)
    Y.INTRNL.AMT   = R.NEW(REDO.FC.INTERNAL.AMOUNT)
    Y.LIM.EXP.DATE = R.NEW(REDO.FC.EXPIRY.DATE)
    Y.LIMIT.REF.ID = R.NEW(REDO.FC.ID.LIMIT)
    Y.APPVL.DATE   = R.NEW(REDO.FC.APPROVAL.DATE)
    Y.OFFER.UNTIL  = R.NEW(REDO.FC.OFFERED.UNTIL)
    Y.NOTES        = R.NEW(REDO.FC.NOTES)
    Y.INTRNL.AMT   = R.NEW(REDO.FC.INTERNAL.AMOUNT)
    Y.MAX.TOTAL    = R.NEW(REDO.FC.MAXIMUM.TOTAL)
    Y.AVAIL.MKR    = R.NEW(REDO.FC.AVAILABLE.MARKER)
    Y.PROPOSAL     = R.NEW(REDO.FC.PROPO.SAL.DATE)

    IF R.NEW(REDO.FC.SECURED) THEN
        Y.COLL.CODE    = R.NEW(REDO.FC.COLLATERAL.CODE)     ;* This indicate if we have or not create a collateral
    END
    Y.CURRENCY     = R.NEW(REDO.FC.LOAN.CURRENCY)

* Create Parent LIMIT
* Al ser un nuevo LIMIT, Y.LIMIT.REF.ID seria NULL!
    Y.LIMIT.SEQ    = Y.LIMIT.REF.ID[".",2,1]
    Y.LIMIT.ID     = Y.LIMIT.REF.ID[".",1,1]
    Y.LIMIT.ID     = Y.LIMIT.ID[1,LEN(Y.LIMIT.ID)-2]
    Y.LIMIT.ID     = FMT(Y.LIMIT.ID : "00.","8'0'R")
    Y.LIMIT.ID     = Y.CUSTOMER.ID : "." : Y.LIMIT.ID : Y.LIMIT.SEQ

* Check if exist in history file for Parent ID
    GOSUB READ.HISTORY

    CALL F.READ(FN.LIMIT, Y.LIMIT.ID, R.LIMIT, F.LIMIT, Y.ERR)

    IF R.LIMIT NE '' THEN
* The current limit was granted for a different Currency, then try with the next available sequence
*IF R.LIMIT<LI.LIMIT.CURRENCY> NE Y.CURRENCY THEN
**** PACS00254642 -    For each child limit, there should be only one parent - PACS00254642 ****
**** Manually created child should not used in automatic creation ****

        Y.LIMIT.SEQ ++
        Y.LIMIT.SEQ = FMT(Y.LIMIT.SEQ,"2'0'R")
        R.NEW(REDO.FC.ID.LIMIT) = R.NEW(REDO.FC.ID.LIMIT)[".",1,1] : "." : Y.LIMIT.SEQ
        Y.PRODUCT = R.NEW(REDO.FC.ID.LIMIT)[".",1,1] : "." : Y.LIMIT.SEQ
        RETURN      ;* Please try again WITH the NEXT sequence on LIMIT.REFERENCE, I can not use GOTO
*END

* Parent Limit already exists then update the INTERNAL.AMOUNT
*R.LIMIT.INPUT = ''
*R.LIMIT.INPUT<LI.INTERNAL.AMOUNT>  = R.LIMIT<LI.INTERNAL.AMOUNT> + Y.INTRNL.AMT
*R.LIMIT.INPUT<LI.MAXIMUM.TOTAL>    = R.LIMIT<LI.INTERNAL.AMOUNT> + Y.INTRNL.AMT

*IF R.LIMIT<LI.EXPIRY.DATE> LT Y.LIM.EXP.DATE THEN
*R.LIMIT.INPUT<LI.EXPIRY.DATE>   = Y.LIM.EXP.DATE
*END

*GOSUB PROCESS.LIMIT.OFS
    END ELSE
* Create Parent Limit
        Y.IS.CHILD.LIMIT = 0
        GOSUB CREATE.LIMIT.RECORD
        GOSUB CHECK.PROCESS
    END

    R.NEW(REDO.FC.ID.LIMIT) = Y.PRODUCT

* Always should create the child limit
    Y.IS.CHILD.LIMIT = 1
    Y.LIMIT.ID = Y.CUSTOMER.ID : "." : FMT(R.NEW(REDO.FC.ID.LIMIT),"10'0'R")

* Check if exist in history file for Parent ID
    GOSUB READ.HISTORY

* Create child limit

    GOSUB CREATE.LIMIT.RECORD
    GOSUB CHECK.PROCESS

    Y.RETRY.NEXT.LIM.SEQ = '0'          ;* Process Finish, don't re-try
    Y.LIMIT.CHILD.ID =  Y.LIMIT.ID      ;* Id of the Child Limit

    RETURN
* </region>

* <region name="PROCESS.LIMIT.OFS" description="Process LIMIT OFS Message">
PROCESS.LIMIT.OFS:
    OFS.INFO.INPUT<2,4> = Y.LIMIT.ID
*Y.OFS.MSG.REQ = DYN.TO.OFS(R.LIMIT.INPUT, Y.APPLICATION, OFS.INFO.INPUT)
    CALL OFS.BUILD.RECORD(Y.APPLICATION, OFS.INFO.INPUT<1,2> ,OFS.INFO.INPUT<2,1>, "LIMIT,APAP", "", OFS.INFO.INPUT<2,6>, OFS.INFO.INPUT<2,4>, R.LIMIT.INPUT, Y.OFS.MSG.REQ)
* Process OFS Message
    CALL REDO.UTIL.PROCESS.OFS(Y.OFS.MSG.REQ, Y.OFS.MSG.RES)
    GOSUB CHECK.PROCESS
    IF Y.ERR THEN
        RETURN
    END

*R.LIMIT.RES = OFS.TO.DYN(Y.OFS.MSG.RES,Y.APPLICATION,Y.OFS.INFO)
*IF R.LIMIT.RES<LI.OVERRIDE> NE '' THEN
*         JV 20120424 - PACS 167218 No se desea que se muestre lo Overrides de Limites segun lo solicitado por MLM
*         CALL F.READ(FN.APP.HIS,Y.APP.ID,R.APP.HIS,F.APP.HIS,Y.ERR)
*  *         Y.OVERRIDE = R.LIMIT.RES<LI.OVERRIDE>
*         CHANGE VM TO FM IN Y.OVERRIDE
*         R.LIMIT.RES<LI.OVERRIDE> = ''
*         * PAC00165068 TRADUCE TODOS LOS MENSAJES DE OVERRIDE QUE PROVENGAN DEL OFS Y VALIDA QUE LOS MISMOS NO SE REPITAN
*         LOOP
*            REMOVE MSG FROM Y.OVERRIDE SETTING POS
*         WHILE MSG:POS
*            CHANGE '}' TO '' IN MSG
*            CALL TXT(MSG)
*            MSG = Y.APPLICATION : ' - ' : MSG
*            LOCATE MSG IN R.NEW(REDO.FC.OVERRIDE)<1,1> SETTING OVER.POS ELSE
*               R.LIMIT.RES<LI.OVERRIDE,-1> = MSG
*            END
*         REPEAT
*Y.OVERRIDE.MSG = Y.APPLICATION : ' - ' : R.LIMIT.RES<LI.OVERRIDE>
*         Y.OVERRIDE.MSG =  R.LIMIT.RES<LI.OVERRIDE>
*         R.NEW(REDO.FC.OVERRIDE) = R.NEW(REDO.FC.OVERRIDE) : VM : Y.OVERRIDE.MSG
*    END

    RETURN
* </region>

* <region name="CREATE.LIMIT.RECORD" description="Build the LIMIT record">
CREATE.LIMIT.RECORD:
    R.LIMIT.INPUT = ''
    R.LIMIT.INPUT<LI.LIMIT.CURRENCY>   = Y.CURRENCY
    R.LIMIT.INPUT<LI.APPROVAL.DATE>    = Y.APPVL.DATE
    R.LIMIT.INPUT<LI.OFFERED.UNTIL>    = Y.OFFER.UNTIL
    R.LIMIT.INPUT<LI.EXPIRY.DATE>      = Y.LIM.EXP.DATE
    R.LIMIT.INPUT<LI.INTERNAL.AMOUNT>  = Y.INTRNL.AMT
    R.LIMIT.INPUT<LI.MAXIMUM.TOTAL>    = Y.MAX.TOTAL
    R.LIMIT.INPUT<LI.NOTES>            = Y.NOTES
    R.LIMIT.INPUT<LI.AVAILABLE.MARKER> = Y.AVAIL.MKR
    R.LIMIT.INPUT<LI.PROPOSAL.DATE>    = Y.PROPOSAL
*R.LIMIT.INPUT<LI.LOCAL.REF,POS.L.AVL.BALANCE> = 0
    GOSUB GET.REVIEW.DATE

* It's a child limit ? the limit must be a secured limit ?
    IF Y.IS.CHILD.LIMIT AND R.NEW(REDO.FC.SECURED) EQ 'SI' THEN
        R.LIMIT.INPUT<LI.FIXED.VARIABLE>   = 'FIXED'
        GOSUB SET.COLLATERAL
    END ELSE
        R.LIMIT.INPUT<LI.FIXED.VARIABLE>   = 'FIXED'
    END

    GOSUB PROCESS.LIMIT.OFS

    RETURN
* </region>

* <region name="GET.REVIEW.DATE" description="Get Review Date">
GET.REVIEW.DATE:
* By default the REVIEW.DATE is one year after today
*JV03042012 commented because in all cases REVIEW.FRECUENCY has to be the EXPIRY.DATE
*Y.MAT.DATE = "1Y"
*R.LIMIT.INPUT<LI.REVIEW.FREQUENCY> = ''
*CALL CALENDAR.DAY(TODAY,'+',Y.MAT.DATE)

*      IF Y.MAT.DATE GT R.LIMIT.INPUT<LI.EXPIRY.DATE> THEN
    R.LIMIT.INPUT<LI.REVIEW.FREQUENCY> = R.LIMIT.INPUT<LI.EXPIRY.DATE> : "M0101"
*      END
    RETURN
* </region>

* <region name="CHECK.PROCESS" description="Check Process">
CHECK.PROCESS:
    IF E NE '' THEN
        ETEXT = E
        Y.ERR = 1
    END ELSE
        Y.ERR = 0
    END

    RETURN
* </region>

* <region name="GET.CATEGORY.CODE" description="Get Category Code">
GET.CATEGORY.CODE:
    Y.LIMIT.CATEGORY.CODE = ''

    SEL.CMD  = 'SELECT ' :FN.AA.PRD.CAT.ACCOUNT
    SEL.CMD := '  LIKE ' :R.NEW(REDO.FC.PRODUCT): '-... BY-DSND @ID'
    SEL.LIST = ''
    NO.REC   = ''
    SEL.ERR  = ''
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '', NO.REC, SEL.ERR)
    IF SEL.ERR NE '' THEN
        REMOVE ID.PRODUCT FROM SEL.LIST SETTING POS
        CALL CACHE.READ(FN.AA.PRD.CAT.ACCOUNT, ID.PRODUCT, R.AA.PRD.CAT.ACCOUNT, Y.ERR)
        Y.LIMIT.CATEGORY.CODE = R.AA.PRD.CAT.ACCOUNT<AA.AC.CATEGORY>
    END ELSE
        Y.LIMIT.CATEGORY.CODE = ''
        ETEXT = E
        CALL STORE.END.ERROR
    END

    RETURN
* </region>

* <region name="READ.HISTORY" description="Reading history records">
READ.HISTORY:
    FN.APP.HIS = 'F.LIMIT$HIS'
    F.APP.HIS = ''
    R.APP.HIS = ''

    Y.ERR = ''
    Y.APP.ID = Y.LIMIT.ID : ';1'

    CALL OPF(FN.APP.HIS,F.APP.HIS)
    CALL F.READ(FN.APP.HIS,Y.APP.ID,R.APP.HIS,F.APP.HIS,Y.ERR)

    IF NOT(Y.ERR) AND R.APP.HIS THEN
        LOOP WHILE R.APP.HIS DO
            YNO.SEQ ++
            Y.PRODUCT = Y.PRODUCT['.',1,1] : '.' : YNO.SEQ
            Y.LIMIT.ID = Y.APP.ID['.',1,1] : '.' : Y.APP.ID['.',2,1] : '.' : YNO.SEQ
            Y.APP.ID = Y.LIMIT.ID  : ';1'

            CALL F.READ(FN.APP.HIS,Y.APP.ID,R.APP.HIS,F.APP.HIS,Y.ERR)
        REPEAT
    END

    RETURN
* </region>
* <region name="SET.COLLATERAL" description="Looking">
SET.COLLATERAL:
    R.LIMIT.INPUT<LI.COLLATERAL.CODE> = ''
    R.LIMIT.INPUT<LI.MAXIMUM.SECURED> = ''

    Y.COLL.NUM = R.NEW(REDO.FC.TYPE.OF.SEC.DI)<1,1>
*Y.MAX.VAL  = SUM(R.NEW(REDO.FC.SEC.VALUE.DI))

    IF Y.COLL.NUM THEN
        GOSUB ADD.COLLATERAL.CODE
    END

    Y.COLL.NUM = R.NEW(REDO.FC.TYPE.OF.SEC.VS)<1,1>
* Y.MAX.VAL  = SUM(R.NEW(REDO.FC.SEC.VALUE.VS))

    IF Y.COLL.NUM THEN
        GOSUB ADD.COLLATERAL.CODE
    END

    Y.COLL.NUM = R.NEW(REDO.FC.TYPE.OF.SEC.BR)<1,1>
* Y.MAX.VAL  = SUM(R.NEW(REDO.FC.SEC.VALUE.BR))

    IF Y.COLL.NUM THEN
        GOSUB ADD.COLLATERAL.CODE
    END
    Y.COLL.NUM = R.NEW(REDO.FC.TYPE.OF.SEC.TP)<1,1>
*Y.MAX.VAL  = SUM(R.NEW(REDO.FC.SEC.VALUE.TP))
    IF Y.COLL.NUM THEN
        GOSUB ADD.COLLATERAL.CODE
    END

    Y.COLL.NUM = R.NEW(REDO.FC.TYPE.OF.SEC.FS)<1,1>
*Y.MAX.VAL  = SUM(R.NEW(REDO.FC.SEC.VALUE.FS))

    IF Y.COLL.NUM THEN
        GOSUB ADD.COLLATERAL.CODE
    END

    Y.COLL.NUM = R.NEW(REDO.FC.TYPE.OF.SEC.DE)<1,1>
* Y.MAX.VAL  = SUM(R.NEW(REDO.FC.SEC.VALUE.DE))

    IF Y.COLL.NUM THEN
        GOSUB ADD.COLLATERAL.CODE
    END

    RETURN
* </region>
* <region name="SET.COLLATERAL" description="Looking">
ADD.COLLATERAL.CODE:
    IF R.LIMIT.INPUT<LI.COLLATERAL.CODE> THEN
        R.LIMIT.INPUT<LI.COLLATERAL.CODE> := VM : Y.COLL.NUM
        R.LIMIT.INPUT<LI.MAXIMUM.SECURED> := VM : Y.INTRNL.AMT
    END
    ELSE
        R.LIMIT.INPUT<LI.COLLATERAL.CODE>  = Y.COLL.NUM
        R.LIMIT.INPUT<LI.MAXIMUM.SECURED> = Y.INTRNL.AMT
    END
    RETURN
*</region'>
END
