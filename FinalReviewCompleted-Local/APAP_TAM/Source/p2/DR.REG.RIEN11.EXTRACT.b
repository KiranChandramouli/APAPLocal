* @ValidationCode : MjoyODMxMDAyODY6Q3AxMjUyOjE2ODQ0OTEwMjYyNTQ6SVRTUzotMTotMTo4Mjk6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 829
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE DR.REG.RIEN11.EXTRACT(REC.ID)
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.RIEN11.EXTRACT
* Date           : 2-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the Customer Details for
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date       Author              Modification Description
* 08/07/2014  Ashokkumar.V.P         PACS00312712 - Updated selection criteria and field length
* 04/10/2014  Ashokkumar.V.P         PACS00312712 - Added for minor customer.
* 20/11/2014  Ashokkumar.V.P         PACS00312712 - Changed to show the Field9 with field4 GL code.
* Date                  who                   Reference
* 24-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND $INCLUDE REGREP.BP TO $INSERT AND $INCLUDE LAPAP.BP TO $INSERT AND FM TO @FM
* 24-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.DATES
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.EB.CONTRACT.BALANCES;* Added by M.Medina
    $INSERT I_F.RE.STAT.REP.LINE;* Added by M.Medina
    $INSERT I_F.TRANSACTION

    $INSERT I_F.REDO.AZACC.DESC
    $INSERT I_DR.REG.RIEN11.EXTRACT.COMMON
    $INSERT I_F.DR.REG.RIEN11.PARAM
    $USING APAP.LAPAP

    GOSUB PROCESS
RETURN

PROCESS:
********
    CALL F.READ(FN.ACCT.ENT.LWORK.DAY, REC.ID, R.ACCT.ENT.LWORK.DAY, F.ACCT.ENT.LWORK.DAY, ERR.ACCT.LWORK)
    CTR.STMT.ID = 1
    CNT.STMT.ID = DCOUNT(R.ACCT.ENT.LWORK.DAY,@FM)
    LOOP
    WHILE CTR.STMT.ID LE CNT.STMT.ID
        STMT.ID = R.ACCT.ENT.LWORK.DAY<CTR.STMT.ID>
        CALL F.READ(FN.STMT.ENTRY,STMT.ID,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ENTRY.ERR)
        IF R.STMT.ENTRY THEN
            GOSUB GET.REPORT.FLD.VALUES
        END
        CTR.STMT.ID += 1
    REPEAT
RETURN
*-----------------------------------------------------------------------------------
INIT.FLD:
*-------*
    FLD = ''; FLD1 = ''; FLD2 = ''; FLD3 = ''; FLD4 = ''; FLD5 = ''
    FLD6 = ''; FLD7 = ''; FLD8 = ''; FLD9 = ''; FLD10 = ''
    R.DR.REG.RIEN11.WORKFILE = ''; AC.COMP = ''; YT.FLD3 = ''
RETURN
*-----------------------------------------------------------------------------------
GET.REPORT.FLD.VALUES:
*--------------------*
*
    GOSUB INIT.FLD
*
    BOOK.DATE = R.STMT.ENTRY<AC.STE.BOOKING.DATE>
    PRD.CATEGORY = ''
    PRD.CATEGORY = R.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY>    ;* S / PACS00312712

    LOCATE PRD.CATEGORY IN CATEG.LST.VAL<1,1> SETTING CAT.POSN THEN
    END ELSE
        RETURN
    END

    FLD1 = BOOK.DATE[7,2]:"/":BOOK.DATE[5,2]:"/":BOOK.DATE[1,4]
*
    CUS.ID = R.STMT.ENTRY<AC.STE.CUSTOMER.ID>
    GOSUB READ.CUSTOMER
*
    FLD3 = R.STMT.ENTRY<AC.STE.ACCOUNT.NUMBER>
    Y.ALT.ACCT.TYPE = ''; Y.ALT.ACCT.ID = ''; Y.PREV.ACCOUNT = ''; OUT.ARR = ''
    CALL F.READ(FN.ACCOUNT,FLD3,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    AC.COMP = R.ACCOUNT<AC.CO.CODE>
    Y.ALT.ACCT.TYPE=R.ACCOUNT<AC.ALT.ACCT.TYPE>
    Y.ALT.ACCT.ID=R.ACCOUNT<AC.ALT.ACCT.ID>
    LOCATE 'ALTERNO1' IN Y.ALT.ACCT.TYPE<1,1> SETTING ALT.TYPE.POS THEN
        Y.PREV.ACCOUNT = Y.ALT.ACCT.ID<1,ALT.TYPE.POS>
    END

    CALL APAP.LAPAP.drRegGetCustType(R.CUSTOMER,OUT.ARR);* R22 Manual conversion
    FLD8 = OUT.ARR<1>
    FLD2 = OUT.ARR<2>
    FLD5 = STMT.ID
    GOSUB GET.FLD6
    CCY.1 = R.STMT.ENTRY<AC.STE.CURRENCY>
    CCY.POS = ''

    LOCATE CCY.1 IN Y.TXNCCY.VAL.ARR<1,1> SETTING CCY.POS THEN
        FLD7 = Y.TXNCCY.DIS.ARR<1,CCY.POS>
    END

*    FLD9 = FLD4   ;* PACS00312712
    FLAG = 0
    IF CCY.1 EQ LCCY THEN
        FLD10 = R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
        FLAG = 1
    END ELSE
        FLAG = 2
        FLD10 = R.STMT.ENTRY<AC.STE.AMOUNT.FCY>
    END
    GOSUB GET.FLD4
    IF Y.PREV.ACCOUNT THEN
        FLD3 = Y.PREV.ACCOUNT
    END
*    FLD = FLD1:FLD.DEL:FLD2:FLD.DEL:FLD3:FLD.DEL:FLD4:FLD.DEL:FLD5:FLD.DEL:FLD6:FLD.DEL:FLD7:FLD.DEL:FLD8:FLD.DEL:FLD9:FLD.DEL:FLD10
    FLD1 = FMT(FLD1,'L#10')
    FLD10 = FMT(FLD10,'R2%17')
    FLD = FLD1:FLD.DEL:FMT(FLD2,'L#30'):FLD.DEL:FMT(FLD3,'L#30'):FLD.DEL:FMT(FLD4,'L#30'):FLD.DEL:FMT(FLD5,'L#60'):FLD.DEL:FMT(FLD6,'L#10'):FLD.DEL:FMT(FLD7,'R%2'):FLD.DEL:FMT(FLD8,'L#2'):FLD.DEL:FMT(FLD9,'L#30'):FLD.DEL:FLD10    ;* PACS00312712

    TIME.STAMP.VAL=TIMEDATE()
    Y.DATE = TODAY
    Y.TIME = FIELD(TIME.STAMP.VAL,' ',1)
    Y.TIME = FIELD(Y.TIME,':',1,2)
    CHANGE ":" TO '' IN Y.TIME
    Y.DATE.TIME = Y.DATE[9,2]:Y.DATE[1,2]:Y.DATE[4,2]:Y.TIME

    R.DR.REG.RIEN11.WORKFILE = FLD
    Y.REC.ID = ''; YSTMT.VL = ''
    YSTMT.VL = FIELD(STMT.ID,'.','2')
    Y.REC.ID = REC.ID:'.':STMT.ID:'-':Y.DATE.TIME

    R.DR.REG.RIEN11.WORKFILE = FLD
    IF FLAG EQ 1 THEN
        GOSUB UPDATE.WORKFILE
    END
    IF FLAG EQ 2 THEN
        GOSUB UPDATE.WORKFILE.FCY
    END
RETURN

READ.CUSTOMER:
**************
    CUSTOMER.ERR = ''; R.CUSTOMER = ''
    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
RETURN

GET.FLD6:
*********
    TXN.CODE = R.STMT.ENTRY<AC.STE.TRANSACTION.CODE>
    CALL F.READ(FN.TRANSACTION,TXN.CODE,R.TRANSACTION,F.TRANSACTION,ERR.TRANSACTION)
    FLD6 = R.TRANSACTION<AC.TRA.LOCAL.REF,L.TXN.CODE.POS>
    IF FLD6 NE '' THEN
        RETURN
    END

    TXNCDE.POS = ''
    LOCATE TXN.CODE IN Y.TXNCDE.VAL.ARR<1,1> SETTING TXNCDE.POS THEN
        FLD6 = Y.TXNCDE.DIS.ARR<1,TXNCDE.POS>
    END
RETURN

GET.FLD4:
********
*
    YCRF.TYPE = ''; FLD4 = ''; FLD9 = ''
    CONSOL.KEY.VAL = R.STMT.ENTRY<AC.STE.CONSOL.KEY>
    YCRF.TYPE = R.STMT.ENTRY<AC.STE.CRF.TYPE>
    GOSUB DEF.DESC.CRF.DC
    FLD9 = FLD4
RETURN

DEF.DESC.CRF.DC:
****************
    IF (YCRF.TYPE EQ 'DEBIT' OR YCRF.TYPE EQ 'CREDIT') THEN
        Y.REGULATORY.AC.ACC = ''; R.EB.CONTRACT.BALANCES = ''; Y.IN.CONSOL.KEY = ''
        CALL F.READ(FN.EB.CONTRACT.BALANCES,REC.ID,R.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES,EB.CONTRACT.BALANCES.ERR)
        IF R.EB.CONTRACT.BALANCES THEN
            Y.CONSOL.KEY = R.EB.CONTRACT.BALANCES<ECB.CONSOL.KEY>
            IF Y.CONSOL.KEY THEN
                Y.CONSOL.PART = FIELD(Y.CONSOL.KEY,'.',1,16)
                Y.IN.CONSOL.KEY = Y.CONSOL.PART:'.':YCRF.TYPE
                Y.VARIABLE = ''; Y.RPRTS = ''; Y.LINES = ''
                CALL RE.CALCUL.REP.AL.LINE(Y.IN.CONSOL.KEY,Y.RPRTS,Y.LINES,Y.VARIABLE)
                Y.LINE = Y.RPRTS:'.':Y.LINES
                CALL F.READ(FN.RE.STAT.REP.LINE,Y.LINE,R.LINE,F.RE.STAT.REP.LINE,REP.ERR)
                Y.REGULATORY.ACC.NO = R.LINE<RE.SRL.DESC,1>
                FLD4 = Y.REGULATORY.ACC.NO
            END
        END
    END
RETURN

UPDATE.WORKFILE:
****************
*
    CALL F.WRITE(FN.DR.REG.RIEN11.WORKFILE,Y.REC.ID,R.DR.REG.RIEN11.WORKFILE)
RETURN
*-----------------------------------------------------------------------------------
UPDATE.WORKFILE.FCY:
*------------------*
*
    CALL F.WRITE(FN.DR.REG.RIEN11.WORKFILE.FCY,Y.REC.ID,R.DR.REG.RIEN11.WORKFILE)
RETURN
*-----------------------------------------------------------------------------------
END
