* @ValidationCode : MjotMTU1NDE1NTA2NzpDcDEyNTI6MTY4MTcyNzExMDAzNTphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 Apr 2023 15:55:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.WIT.R32(Y.OUT.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.WIT.R32
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.WIT is an No-file enquiry routine, this routine is used to
*                    extract data from relevant files so as to display in the CASH WINDOW TRANSACTION report
*                    with WITHDRAWALS details
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.WIT
*In  Parameter     : NA
*Out Parameter     : Y.OUT.ARRAY - Output array for display
*Files  Used       : REDO.H.TELLER.TXN.CODES          As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 09 JUN 2011       MARIMUTHU S                  ODR-2011-04-0007   32                Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*17-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FMto@FM,VMto@VM,SMto@SM
*17-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION CALL RTN FORMAT CAN MODIFIED
*----------------------------------------------------------------------------------------

*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.H.TELLER.TXN.CODES
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
RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    Y.FINAL.ARRAY = ''
    Y.CCY.LIST = LCCY
    REDO.H.TELLER.TXN.CODES.ID = 'SYSTEM'
    GOSUB READ.REDO.H.TELLER.TXN.CODES
    GOSUB GET.SAV.CURR.DEBIT.DETAILS
*    GOSUB GET.SHORTAGE.AMT
*    GOSUB GET.CASH.TELLER.TXN
    GOSUB ADD.STATIC.TEXT
    GOSUB CONVERT.TO.STARS
RETURN
*--------------------------------------------------------------------------------------------------------
********************
GET.CASH.TELLER.TXN:
********************
*    CALL REDO.APAP.NOF.CASH.WINDOW.WIT.CTT.R32(Y.CCY.LIST,Y.FINAL.ARRAY,SET.CUR,Y.DUP.CUR)
RETURN
*--------------------------------------------------------------------------------------------------------
***************************
GET.SAV.CURR.DEBIT.DETAILS:
***************************
* In this para of the code, the TELLER TRANSACTION details are read and checked if the transaction can be
** consdiered or not for calculations and display

    CALL APAP.REDOAPAP.REDO.APAP.NOF.CASH.WINDOW.WIT.SAV.CUR.R32(Y.CCY.LIST,R.REDO.H.TELLER.TXN.CODES,Y.FINAL.ARRAY,SET.CUR,Y.DUP.CUR);*R22 MANUAL CODE CONVERSION
RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.SHORTAGE.AMT:
*****************
* In this para of the code, the SHORTAGE amount details are fetched

*    CALL REDO.APAP.NOF.CASH.WINDOW.WIT.SHORTAGE.R32(Y.CCY.LIST,Y.FINAL.ARRAY,SET.CUR,Y.DUP.CUR)
RETURN
*--------------------------------------------------------------------------------------------------------
****************
ADD.STATIC.TEXT:
****************
* In this para of the code, a CALL is made to an routine to add the static text in the report for display
    CALL APAP.REDOAPAP.REDO.APAP.NOF.CASH.WINDOW.WIT.TEXT.R32(Y.CCY.LIST,Y.FINAL.ARRAY) ;*R22 AUTO CODE CONVRSION
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
    CHANGE @VM TO @FM  IN Y.FINAL.ARRAY
    CHANGE @SM TO '*' IN Y.FINAL.ARRAY
    Y.OUT.ARRAY = Y.FINAL.ARRAY
RETURN
*--------------------------------------------------------------------------------------------------------
*****************************
READ.REDO.H.TELLER.TXN.CODES:
*****************************
* In this para of the code, file REDO.H.TELLER.TXN.CODES is read
    R.REDO.H.TELLER.TXN.CODES  = '';  REDO.H.TELLER.TXN.CODES.ER = ''
    CALL CACHE.READ(FN.REDO.H.TELLER.TXN.CODES,REDO.H.TELLER.TXN.CODES.ID,R.REDO.H.TELLER.TXN.CODES,REDO.H.TELLER.TXN.CODES.ER)
RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
