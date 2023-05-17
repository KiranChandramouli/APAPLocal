SUBROUTINE REDO.B.FX.PROV.DLY(Y.CUS.ID)
******************************************************************************
*  Company Name      : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : JEEVA T
*  ODR Number        : ODR-2009-11-0159
*  Program Name      : REDO.B.FX.PROV.DLY
*-----------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* DESCRIPTION       : This BATCH routine is to calculate CUSTOMER provision
*                     values based on the arrangements with the CUSTOMER during COB
*------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE            WHO         REFERENCE            DESCRIPTION
*  -----           ----        ----------           -----------
*  22-Oct-2010    JEEVA T    ODR-2009-11-0159     INITIAL CREATION
*-------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.CURRENCY
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_REDO.B.FX.PROV.DLY.COMMON
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT
    $INSERT I_F.ACCOUNT


    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------
    SEL.LIST.ARR = ''

    CALL F.READ(FN.REDO.CUSTOMER.ARRANGEMENT,Y.CUS.ID,R.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT,Y.ERR.AC)
    SEL.LIST.ARR = R.REDO.CUSTOMER.ARRANGEMENT<CUS.ARR.OWNER>
    IF SEL.LIST.ARR EQ '' THEN
        RETURN
    END
    LOOP
        REMOVE Y.AA.ID FROM SEL.LIST.ARR SETTING ARR.POS
    WHILE Y.AA.ID:ARR.POS
        GOSUB NULLIFY

        GOSUB GET.LOCAL.CURRENCY
        IF Y.FLAG EQ '1' THEN
            CONTINUE
        END
        IF Y.CURRENCY EQ '' THEN
            CONTINUE
        END
        GOSUB FX.PROVISION
    REPEAT
RETURN
*-------------------------------------------------------------------------------
NULLIFY:
*-------------------------------------------------------------------------------
    Y.FLAG              = ''  ; Y.CURRENCY    = ''
    Y.MID.REVEAL.RATE   = '0'  ; Y.AMT         = '0'
    Y.CURRENCY.MARKET   = ''  ; Y.TOTAL.VALUE = '0'
    OUSTANDING.LOAN.AMT = '0'  ; Y.FLAG1       = ''
    LAST.UPD.LINE       = ''  ; NEW.LINE      = ''
    TOTAL.PROFIT        = '0' ; Y.DIFF        = '0'
    DIFF.VAL            = '0'
RETURN
*-------------------------------------------------------------------------------
GET.LOCAL.CURRENCY:
*-------------------------------------------------------------------------------
    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,Y.AA.ERR)

    IF R.AA.ARRANGEMENT THEN
        Y.CURRENCY = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
        Y.ACCT.NO  = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    END

    IF Y.CURRENCY EQ 'DOP' THEN
        Y.FLAG = '1'
    END

RETURN
*-------------------------------------------------------------------------------
GET.PERIOD.BALANCES:
*-------------------------------------------------------------------------------
    DATE.OPTIONS    = ''
    EFFECTIVE.DATE  = TODAY
    DATE.OPTIONS<4>  = 'ECB'
    BALANCE.DETAILS = ""
    CALL AA.GET.PERIOD.BALANCES(Y.ACCT.NO, BALANCE.TO.CHECK, DATE.OPTIONS, EFFECTIVE.DATE, "", "", BAL.DETAILS, "")

    Y.AMT           =  BAL.DETAILS<IC.ACT.BALANCE>
RETURN
*-------------------------------------------------------------------------------
FX.PROVISION:
*----------------------------------------------------------------------------

    BALANCE.TO.CHECK    = 'CURACCOUNT'
    GOSUB GET.PERIOD.BALANCES
    OUSTANDING.LOAN.AMT = ABS(Y.AMT)

    IF Y.FLAG EQ '' THEN
        CALL F.READ(FN.CURRENCY,Y.CURRENCY,R.CURRENCY,F.CURRENCY,Y.CURR.ERR)
        Y.CURRENCY.MARKET = R.CURRENCY<EB.CUR.CURRENCY.MARKET>
        Y.MID.REVEAL.RATE = R.CURRENCY<EB.CUR.MID.REVAL.RATE>
        LOCATE "1" IN Y.CURRENCY.MARKET<1,1> SETTING MRKT.POS THEN
            Y.TOTAL.VALUE = OUSTANDING.LOAN.AMT*Y.MID.REVEAL.RATE<1,MRKT.POS>
        END
        GOSUB FILE.CREATE.UPDATE
    END

RETURN
*-------------------------------------------------------------------------------------------------------
FILE.CREATE.UPDATE:
*-------------------------------------------------------------------------------------------------------
    GOSUB FILE.CREATION
    LOOP
        READSEQ Y.VALUE FROM F.PATH THEN
            LAST.UPD.LINE = Y.VALUE
        END ELSE
            IF Y.FLAG1 NE '1' THEN
                BREAK
            END
            IF Y.FLAG1 EQ '1' THEN
                LAST.UPD.LINE =  TODAY:'*':Y.TOTAL.VALUE:'*':DIFF.VAL:'*':TOTAL.PROFIT
                BREAK
            END
        END
    REPEAT
    GOSUB FILE.UPDATE
RETURN
*-------------------------------------------------------------------------------------------------------
FILE.CREATION:
*-------------------------------------------------------------------------------------------------------
    Y.FX.PROVISION.ID = Y.CUS.ID:".":Y.AA.ID:".":Y.CURRENCY
    Y.PATH = '../bnk.data'
    OPENSEQ Y.PATH,Y.FX.PROVISION.ID TO F.PATH ELSE
        Y.FLAG1 = '1'
        CREATE F.PATH ELSE
            OPEN.ERR = 'Unable to Open/Create ':Y.PATH:" ":Y.FX.PROVISION.ID
            CALL EXCEPTION.LOG("S","BNK/REDO.B.PROV.CALC","REDO.B.FX.PROV.DLY","",001,"",Y.PATH,Y.FX.PROVISION.ID,"",OPEN.ERR,"")
        END
    END
RETURN
*-------------------------------------------------------------------------------------------------------
FILE.UPDATE:
*-------------------------------------------------------------------------------------------------------
    LAST.VALUE = FIELD(LAST.UPD.LINE,"*",2)
    LAST.DIFF = FIELD(LAST.UPD.LINE,"*",3)
    TOTAL.PROFIT = FIELD(LAST.UPD.LINE,"*",4)
    Y.DIFF = Y.TOTAL.VALUE - LAST.VALUE
    IF Y.DIFF GT 0 THEN
        DIFF.VAL = Y.DIFF
    END ELSE
        DIFF.VAL = 0
    END
    TOTAL.PROFIT += DIFF.VAL
    NEW.LINE = TODAY:'*':Y.TOTAL.VALUE:'*':DIFF.VAL:'*':TOTAL.PROFIT

    WRITESEQ NEW.LINE APPEND TO F.PATH ELSE
        OPEN.ERR = 'Unable to Write in ':Y.PATH:" ":Y.FX.PROVISION.ID
        CALL EXCEPTION.LOG("S","BNK/REDO.B.PROV.CALC","REDO.B.FX.PROV.DLY","",001,"",Y.PATH,Y.FX.PROVISION.ID,"",OPEN.ERR,"")
    END
RETURN
*-------------------------------------------------------------------------------------------------------
END
