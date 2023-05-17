SUBROUTINE REDO.E.CONV.INVCANCL.AMT

****************************************************
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Pradeep.A
* Program Name : REDO.E.CONV.INVCANCL.AMT
*---------------------------------------------------------
****
* Description : This subroutine is attached as a conversion routine to THE ENQUIRY REDO.E.OPEN.CAN.INVST.REP
* to populate the label MONTO CANCELACION,FORMA DE PAGO CANCELACION,MOTIVO CANCELACION
* Get the VALUE.DATE and MATURITY.DATE from AZ.ACCOUNT and call CDD to calulate the difference between two dates
*
*----------------------------------------------------------
* Linked With : Enquiry REDO.E.OPEN.CAN.INVST.REP
* In Parameter : O.DATA
* Out Parameter : O.DATA,R.RECORD<300>,R.RECORD<301>
*----------------------------------------------------------
* Modification History:
*----------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STMT.ENTRY
*-------------------------------------------------------------------------------------------------------
**********
    GOSUB GET.DATA.FROM.ENQ
    GOSUB INIT.VAR
    GOSUB OPEN.FILES
    GOSUB GET.STMT.ENTRY
***
RETURN
*-------------------------------------------------------------------------------------------------------
*****************
GET.DATA.FROM.ENQ:
******************
    YENQ.SEL = ENQ.SELECTION
    Y.ACCOUNT.NUMBER = ID
    YDATE.POS = ''
***Getting the value from the enquiry selection criteria
****Assigning the position in YDATE.POS
    LOCATE "CREATE.DATE" IN YENQ.SEL<2,1> SETTING YDATE.POS THEN
        YDATE.RANGE = YENQ.SEL<4,YDATE.POS>
    END
***
RETURN
*-------------------------------------------------------------------------------------------------------
***************
GET.STMT.ENTRY:
***************
    CHANGE " " TO @FM IN YDATE.RANGE
    FROM.DATE = YDATE.RANGE<1>
    END.DATE =  YDATE.RANGE<2>
*****Using the CORE routine to fetch the STMT.ENTRY id's for the given specified date range
    CALL EB.ACCT.ENTRY.LIST (Y.ACCOUNT.NUMBER, FROM.DATE, END.DATE, YID.LIST, OPENING.BAL, YERR)
    LOOP
        REMOVE Y.STMT.ID FROM YID.LIST SETTING STMT.POS
    WHILE Y.STMT.ID : STMT.POS
        R.STMT.ENTRY = '' ; ERR.STMT.ENTRY = ''
****Read the STMT.ENTRY for the selected records
        CALL F.READ(FN.STMT.ENTRY,Y.STMT.ID,R.STMT.ENTRY,F.STMT.ENTRY,ERR.STMT.ENTRY)
        IF R.STMT.ENTRY THEN
            YTRANSACTION.CODE = R.STMT.ENTRY<AC.STE.TRANSACTION.CODE>
            IF YTRANSACTION.CODE EQ '381' OR YTRANSACTION.CODE EQ '367' OR YTRANSACTION.CODE EQ '382' THEN
                YTRANSACTION.AMT <-1> = R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
                YTRANS.CODE <-1> = R.STMT.ENTRY<AC.STE.TRANSACTION.CODE>
                YTRANSACTION.DATE <-1> = R.STMT.ENTRY<AC.STE.VALUE.DATE>
                YTRANS.REF <-1> = R.STMT.ENTRY<AC.STE.SYSTEM.ID>
            END
        END
    REPEAT
***Used the LOCATE funtion to find the Preclosure category for the deposit account
    LOCATE "367" IN YTRANS.CODE SETTING TRANS.POS THEN
        YTRANS.CNT = DCOUNT(YTRANS.CODE,@FM)
        FOR I.VAR= TRANS.POS TO YTRANS.CNT
            YTRANS.AMT += YTRANSACTION.AMT<I.VAR>
        NEXT I.VAR
        YTRANS.DATE = YTRANSACTION.DATE<TRANS.POS>
        YTRANS.REFERENCE = YTRANS.REF<TRANS.POS>
    END
    O.DATA = ''
    O.DATA = YTRANS.DATE
    R.RECORD<300> = YTRANS.AMT
    R.RECORD<301> = YTRANS.REFERENCE
RETURN
*-------------------------------------------------------------------------------------------------------
*********
INIT.VAR:
*********
    YTRANSACTION.AMT = ''
    YTRANS.CODE = ''
    YTRANSACTION.DATE = ''
    YTRANSACTION.CODE = ''
    YID.LIST = ''
    OPENING.BAL = ''
    YERR = ''
    Y.STMT.ID = ''
    STMT.POS = ''
    FROM.DATE = ''
    END.DATE = ''
    YTRANS.REFERENCE = ''
    YTRANS.REF = ''
    TRANS.POS = ''
    YTRANS.DATE = ''
    YTRANS.AMT = ''
RETURN
*-------------------------------------------------------------------------------------------------------
**********
OPEN.FILES:
*************
    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)
*-------------------------------------------------------------------------------------------------------
**********
RETURN
END
