SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.DEP(Y.OUT.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.DEP
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.DEP is an No-file enquiry routine, this routine is used to
*                    extract data from relevant files so as to display in the CASH WINDOW TRANSACTION report
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.DEP
*In  Parameter     : NA
*Out Parameter     : Y.OUT.ARRAY - Output array for display
*Files  Used       : REDO.H.TELLER.TXN.CODES          As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 11 Mar 2011       Shiva Prasad Y              ODR-2010-03-0086 35         Initial Creation
* 23 Aug 2011           Riyas                       PACS00104133            Modification(comment this GOSUB GET.SAV.TERM.INST.OPENINGS
*                                                                           and its used in REDO.APAP.NOF.CASH.WINDOW.DEP.SAV.CUR)
* 24 Aug            Pradeep S                       PACS00106559            Multiple product groups handled based on parameter
* 04 Sep 2011       Marimuthu S                     PACS00120772
****************************************************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.H.TELLER.TXN.CODES
    $INSERT I_F.AZ.PRODUCT.PARAMETER
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB OPEN.PARA

    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened
    FN.REDO.H.TELLER.TXN.CODES = 'F.REDO.H.TELLER.TXN.CODES'
    F.REDO.H.TELLER.TXN.CODES  = ''
    CALL OPF(FN.REDO.H.TELLER.TXN.CODES,F.REDO.H.TELLER.TXN.CODES)

    FN.AZ.PRODUCT.PARAMETER = 'F.AZ.PRODUCT.PARAMETER'
    F.AZ.PRODUCT.PARAMETER = ''

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    Y.CCY.LIST = LCCY
    Y.COMPANY.LIST = ''; SET.CUR = ''; Y.DUP.CUR = ''

    REDO.H.TELLER.TXN.CODES.ID = 'SYSTEM'
    GOSUB READ.REDO.H.TELLER.TXN.CODES

    GOSUB GET.SAV.CURR.DEBIT.DETAILS
* GOSUB GET.SAV.TERM.INST.OPENINGS
* GOSUB GET.MTS.DETAILS
*   GOSUB GET.OVERAGE.AMT
    GOSUB ADD.STATIC.TEXT
    GOSUB CONVERT.TO.STARS
RETURN
*--------------------------------------------------------------------------------------------------------
***************************
GET.SAV.CURR.DEBIT.DETAILS:
***************************
* In this para of the code, the TELLER TRANSACTION details are read and checked if the transaction can be
** consdiered or not for calculations and display

    CALL REDO.APAP.NOF.CASH.WINDOW.DEP.SAV.CUR(Y.CCY.LIST,R.REDO.H.TELLER.TXN.CODES,Y.COMPANY.LIST,Y.FINAL.ARRAY,SET.CUR,Y.DUP.CUR)
*    CALL REDO.APAP.NOF.CASH.WINDOW.DEP.SAV.CUR(Y.CCY.LIST,R.REDO.H.TELLER.TXN.CODES,VAR.RE.INV.CATEG,Y.COMPANY.LIST,Y.FINAL.ARRAY)
RETURN
*--------------------------------------------------------------------------------------------------------
***************************
GET.SAV.TERM.INST.OPENINGS:
***************************
* In this para of the code, the AZ.ACCOUNTs are read and TERm INSTRUMENT OPENING transaction details are
** consdiered for calculations and display

*    CALL REDO.APAP.NOF.CASH.WINDOW.DEP.TERM.INST.OPEN(Y.CCY.LIST,R.REDO.H.TELLER.TXN.CODES,Y.FINAL.ARRAY)

RETURN
*--------------------------------------------------------------------------------------------------------
****************
*GET.MTS.DETAILS:
****************
* In this para of the code, this GOSUB will call to a seperate routine which will loop through MTS records
** check for various conditions and process the records

*    CALL REDO.APAP.NOF.CASH.WINDOW.DEP.LOOP.MTS(Y.CCY.LIST,R.REDO.H.TELLER.TXN.CODES,Y.FINAL.ARRAY)

*    RETURN
*--------------------------------------------------------------------------------------------------------
****************
GET.OVERAGE.AMT:
****************
* In this para of the code, the OVERAGE amount details are fetched

*    CALL REDO.APAP.NOF.CASH.WINDOW.DEP.OVERAGE(Y.CCY.LIST,Y.COMPANY.LIST,Y.FINAL.ARRAY)
RETURN
*--------------------------------------------------------------------------------------------------------
****************
ADD.STATIC.TEXT:
****************
* In this para of the code, a CALL is made to an routine to add the static text in the report for display

    CALL REDO.APAP.NOF.CASH.WINDOW.DEP.TEXT.R32(Y.CCY.LIST,Y.COMPANY.LIST,Y.FINAL.ARRAY)

    Y.CNT.FIN = DCOUNT(Y.FINAL.ARRAY,@FM)
    Y.CNTT = 0
    LOOP
    WHILE Y.CNT.FIN GE 0 DO
        Y.CNTT += 1
        IF Y.FINAL.ARRAY<Y.CNTT> EQ '' THEN
            DEL Y.FINAL.ARRAY<Y.CNTT>
        END
        Y.CNT.FIN -= 1
    REPEAT
RETURN
*--------------------------------------------------------------------------------------------------------
*****************
CONVERT.TO.STARS:
*****************
* In this para of the code, the fianl array is formatted so as to display the output in enquiry
*PACS00106559 - S
    Y.FINAL.CNT = DCOUNT(Y.FINAL.ARRAY,@FM)
    Y.FINAL.CTR = 1
    LOOP
    WHILE Y.FINAL.CTR LE Y.FINAL.CNT
        Y.FINAL.CCY = Y.FINAL.ARRAY<Y.FINAL.CTR>
        Y.OTR.LOANS = FIELD(Y.FINAL.CCY,@VM,31,99)
        Y.OTR.LOANS.CNT = DCOUNT(Y.OTR.LOANS,@VM)
        IF Y.OTR.LOANS THEN
            Y.L.CNT = 1
            Y.SUM.POS.3=''
            Y.SUM.POS.4=''
            Y.SUM.POS.5=''
            Y.SUM.POS.6=''
            Y.SUM.POS.7=''
            Y.ADD.POS = ''
            Y.TOTAL.AA.TRANS =''
            Y.FLAG = 1
            LOOP
            WHILE Y.L.CNT LE Y.OTR.LOANS.CNT
                Y.L.POS = 30+Y.ADD.POS
                Y.TEMP.ARR = Y.FINAL.ARRAY<Y.FINAL.CTR,Y.L.POS+1>
                Y.LOAN.PRD = Y.TEMP.ARR<1,1,2>

                Y.SUM.POS.4 += Y.FINAL.ARRAY<Y.FINAL.CTR,Y.L.POS+1,4>
                Y.SUM.POS.5 += Y.FINAL.ARRAY<Y.FINAL.CTR,Y.L.POS+1,5>
                Y.SUM.POS.6 += Y.FINAL.ARRAY<Y.FINAL.CTR,Y.L.POS+1,6>
                Y.FINAL.ARRAY<Y.FINAL.CTR,14,4> = Y.SUM.POS.4
                Y.FINAL.ARRAY<Y.FINAL.CTR,14,5> = Y.SUM.POS.5
                Y.FINAL.ARRAY<Y.FINAL.CTR,14,6> = Y.SUM.POS.6

                IF NOT(Y.LOAN.PRD) THEN
                    DEL Y.FINAL.ARRAY<Y.FINAL.CTR,Y.L.POS+1>
                    Y.TEMP.ARR<1,1,2> = Y.FINAL.ARRAY<Y.FINAL.CTR-1,14,2>
                END ELSE
                    Y.SUM.POS.3 += 1
                    Y.FINAL.ARRAY<Y.FINAL.CTR,14,3> = Y.SUM.POS.3
                    IF Y.FLAG THEN
                        DEL Y.FINAL.ARRAY<Y.FINAL.CTR,Y.L.POS+1>
                        INS Y.TEMP.ARR BEFORE Y.FINAL.ARRAY<Y.FINAL.CTR,14>
                        Y.ADD.POS = 1
                        Y.FLAG = ''
                    END ELSE
                        DEL Y.FINAL.ARRAY<Y.FINAL.CTR,Y.L.POS+1>
                    END
                END

                Y.FINAL.ARRAY<Y.FINAL.CTR,14,7>= Y.FINAL.ARRAY<Y.FINAL.CTR,14,4> + Y.FINAL.ARRAY<Y.FINAL.CTR,14,5> + Y.FINAL.ARRAY<Y.FINAL.CTR,14,6>
                Y.TOTAL.AA.TRANS = Y.FINAL.ARRAY<Y.FINAL.CTR,14,3> + Y.FINAL.ARRAY<Y.FINAL.CTR,13,3>
                Y.FINAL.ARRAY<Y.FINAL.CTR,15,3> = Y.TOTAL.AA.TRANS
                Y.FINAL.ARRAY<Y.FINAL.CTR,15,4> = ''
                Y.FINAL.ARRAY<Y.FINAL.CTR,15,5> = ''
                Y.FINAL.ARRAY<Y.FINAL.CTR,15,6> = ''
                Y.L.CNT += 1
            REPEAT
        END
        Y.FINAL.CTR += 1
    REPEAT

    CHANGE @VM TO @FM  IN Y.FINAL.ARRAY
    CHANGE @SM TO '*' IN Y.FINAL.ARRAY
    Y.OUT.ARRAY = Y.FINAL.ARRAY
*PACS00106559 - E

RETURN
*--------------------------------------------------------------------------------------------------------
*****************************
READ.REDO.H.TELLER.TXN.CODES:
*****************************
* In this para of the code, file REDO.H.TELLER.TXN.CODES is read
    R.REDO.H.TELLER.TXN.CODES  = ''
    REDO.H.TELLER.TXN.CODES.ER = ''
    CALL CACHE.READ(FN.REDO.H.TELLER.TXN.CODES,REDO.H.TELLER.TXN.CODES.ID,R.REDO.H.TELLER.TXN.CODES,REDO.H.TELLER.TXN.CODES.ER)

RETURN
*--------------------------------------------------------------------------------------------------------

END       ;* End of Program
