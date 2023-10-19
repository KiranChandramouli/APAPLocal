$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.LETTER.ISSUE
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.INP.LETTER.ISSUE
* ODR NO      : ODR-2009-10-0838
*----------------------------------------------------------------------
*DESCRIPTION: This is the INPUT Routine for REDO.LETTER.ISSUE Template
* to throw error message



*   IN PARAMETER  :  NA
*   OUT PARAMETER :  NA
*   LINKED WITH   :  REDO.LETTER.ISSUE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*18.03.2010  H GANESH        ODR-2009-10-0838   INITIAL CREATION
*06.09.2011  Sudharsanan S   PACS00120767/65    Check the customer product based on main or joint customer
*22.03.2012  Riyas           PACS00169222       Remove the condition for GOSUB DEFAULT.AMOUNT
*14-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM,F.READ TO CACHE.READ,++ TO +=1
*14-07-2023    VICTORIA S          R22 MANUAL CONVERSION   CALL ROUTINE MODIFIED
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.REDO.LETTER.ISSUE
    $USING APAP.AA
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB LOCAL.REF
    GOSUB PROCESS
RETURN


*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    FN.FT.COMMISSION.TYPE='F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE=''
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    FN.ACCOUNT.HIS='F.ACCOUNT$HIS'
    F.ACCOUNT.HIS=''
RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.ACCOUNT.HIS,F.ACCOUNT.HIS)
RETURN
*----------------------------------------------------------------------
LOCAL.REF:
*----------------------------------------------------------------------
    LOC.REF.APPLICATION="ACCOUNT"
    LOC.REF.FIELDS='L.AC.STATUS1'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AC.STATUS1=LOC.REF.POS<1,1>
RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    Y.CHARGE.KEY=R.NEW(REDO.LET.ISS.CHARGE.KEY)
    CHK.VALUE =1
    IF Y.CHARGE.KEY EQ 'CARTACONS' THEN
*PACS00169222
        GOSUB DEFAULT.AMOUNT
*PACS00169222
    END ELSE
        AF=REDO.LET.ISS.CHARGE.KEY
        ETEXT='EB-FTCOM.LETTER'
        CALL STORE.END.ERROR
    END
    Y.WAIVE=R.NEW(REDO.LET.ISS.WAIVE.CHARGES)
    IF Y.WAIVE EQ 'YES' THEN
        R.NEW(REDO.LET.ISS.CHARGE.LIQ.ACT)=''
        T(REDO.LET.ISS.CHARGE.LIQ.ACT)<3> = 'NOINPUT'
        R.NEW(REDO.LET.ISS.CHARGE.AMT) = ''
        T(REDO.LET.ISS.CHARGE.AMT)<3> = 'NOINPUT'
    END
    GOSUB CUST.HOLD.STATUS
RETURN
*----------------------------------------------------------------------
DEFAULT.AMOUNT:
*----------------------------------------------------------------------

* Defaults the Charge Amount in from FT.COMMISSION.TYPE

    CALL CACHE.READ(FN.FT.COMMISSION.TYPE, Y.CHARGE.KEY, R.FT.COMMISSION.TYPE, COMM.TYPE.ERR) ;*R22 AUTO CONVERSION
    Y.DEFAULT.CCY=R.FT.COMMISSION.TYPE<FT4.DEFAULT.CCY>
    IF Y.DEFAULT.CCY NE '' THEN
        R.NEW(REDO.LET.ISS.CHARGE.CCY)=Y.DEFAULT.CCY
        Y.CURRENCY=R.FT.COMMISSION.TYPE<FT4.CURRENCY>
        LOCATE Y.DEFAULT.CCY IN Y.CURRENCY<1,1> SETTING POS1 THEN
            R.NEW(REDO.LET.ISS.CHARGE.AMT)=R.FT.COMMISSION.TYPE<FT4.FLAT.AMT,POS1>
        END
    END ELSE
        R.NEW(REDO.LET.ISS.CHARGE.CCY)=LCCY
        LOCATE LCCY IN Y.CURRENCY<1,1> SETTING POS1 THEN
            R.NEW(REDO.LET.ISS.CHARGE.AMT)=R.FT.COMMISSION.TYPE<FT4.FLAT.AMT,POS1>
        END
    END
RETURN

*----------------------------------------------------------------------
CUST.HOLD.STATUS:
*----------------------------------------------------------------------
    Y.PRODUCTS=R.NEW(REDO.LET.ISS.PRODUCTS)
    Y.NO.PRODUCTS=DCOUNT(Y.PRODUCTS,@VM) ;*R22 AUTO CONVERSION
    Y.TYPE=R.NEW(REDO.LET.ISS.TYPE.OF.LETTER)
    Y.CUSTOMER.ID = R.NEW(REDO.LET.ISS.CUSTOMER.ID)
    IF Y.TYPE EQ 'AUDITOR' OR Y.TYPE EQ 'CONSULAR' OR Y.TYPE EQ 'INTERNAL' OR Y.TYPE EQ 'INDIVIDUAL' OR Y.TYPE EQ 'COMMERCIAL' THEN
        VAR1=1
        LOOP
        WHILE VAR1 LE Y.NO.PRODUCTS
            Y.PRODUCT.ID=Y.PRODUCTS<1,VAR1>
            CALL F.READ(FN.ACCOUNT,Y.PRODUCT.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
            IF R.ACCOUNT EQ '' THEN
                Y.ACC.ID=Y.PRODUCT.ID
                CALL EB.READ.HISTORY.REC(F.ACCOUNT.HIS,Y.ACC.ID,R.ACCOUNT,YERROR)
                IF R.ACCOUNT EQ '' THEN
                    Y.ACC.ID = Y.PRODUCT.ID:';':CHK.VALUE
                    CALL F.READ(FN.ACCOUNT.HIS,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT.HIS,ACC.ERR)
                END
            END
*PACS00120767 - S
            Y.ACCT.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
            IF Y.ACCT.CUSTOMER EQ Y.CUSTOMER.ID THEN
                R.NEW(REDO.LET.ISS.CUST.HOLD.STATUS)<1,VAR1>='MAIN HOLDER'
            END ELSE
                R.NEW(REDO.LET.ISS.CUST.HOLD.STATUS)<1,VAR1>='JOINT HOLDER'
            END
*PACS00120767 -E
            VAR1 += 1 ;*R22 AUTO CONVERSION
        REPEAT
    END ELSE
        VAR1=1
        LOOP
        WHILE VAR1 LE Y.NO.PRODUCTS
            Y.PRODUCT.ID=Y.PRODUCTS<1,VAR1>
            ARR.ID=Y.PRODUCT.ID
            PROP.CLASS="CUSTOMER"
            PROPERTY=""
*CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
*R22 MANUAL CONVERSION
            APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
*PACS00120767 -S
            IF R.Condition<AA.CUS.CUSTOMER> EQ Y.CUSTOMER.ID THEN
                R.NEW(REDO.LET.ISS.CUST.HOLD.STATUS)<1,VAR1>='MAIN HOLDER'
            END ELSE
                R.NEW(REDO.LET.ISS.CUST.HOLD.STATUS)<1,VAR1>='JOINT HOLDER'
            END
*PACS00120767 - E
            VAR1 += 1 ;*R22 AUTO CONVERSION
        REPEAT
    END
RETURN
*-------------------------------------------------------------------------------------------------------------------------------------
END
