* @ValidationCode : MjotMTQ2NDM4ODE1MTpDcDEyNTI6MTY4NDgzNjA1Mjg5MTpJVFNTOi0xOi0xOi00MjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -42
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.SEL.CR
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.SEL.CR
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the value
*                    from O.DATA delimited with stars and formats them according to the selection criteria
*                    and returns the value back to O.DATA
*Linked With       : Enquiry REDO.INVESTMENT.REINVESTMENT.R94
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
* 13 August 2010      Jeyachandran S       ODR-2010-03-0094 103         Initial Creation
* 30 March 2013       Arundev KR           PACS00260039                 T24 date format , comma delimiter
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*18-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  NO CHANGE
*18-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts


    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    Y.CRITERIA = ''
    Y.DATE = FIELD(O.DATA,'*',1)
    Y.INS.TYPE = FIELD(O.DATA,'*',2)
    Y.CMPNY.CODE = FIELD(O.DATA,'*',3)


    IF Y.DATE THEN
*       Y.DATE1 = "20":Y.DATE[1,6]
*       Y.DATE2 = "20":Y.DATE[12,17]
*       Y.DATE3 = Y.DATE2[1,8]
        Y.DATE1 = Y.DATE[1,8]
        Y.DATE2 = Y.DATE[10,8]
    END

*Y.DATE = Y.DATE1 :' ': Y.DATE2

*PACS00260039-start
*converting date into T24 date format
*Y.DATE1 = FIELD(Y.DATE," ",1)
*Y.DATE1 = ICONV(Y.DATE1,"DJ")
*Y.DATE1 = OCONV(Y.DATE1,"D4E")

*Y.DATE2 = FIELD(Y.DATE," ",2)
*Y.DATE2 = ICONV(Y.DATE2,"DJ")
*Y.DATE2 = OCONV(Y.DATE2,"D4E")

*Y.DATE = Y.DATE1:' ':Y.DATE2
*PACS00260039-end
*END

*PACS00260039-start
*IF Y.DATE THEN
*Y.CRITERIA = 'FECHA - ':Y.DATE:' '
*END

*IF Y.INS.TYPE THEN
*Y.CRITERIA := 'TIPO DE INVERSION - ':Y.INS.TYPE:' '
*END

*IF Y.CMPNY.CODE THEN
*Y.CRITERIA := 'AGENCIA - ':Y.CMPNY.CODE:' '
*END
    IF Y.DATE THEN
        CALL EB.DATE.FORMAT.DISPLAY(Y.DATE1,Y.DATE1.FMT,'','')
        CALL EB.DATE.FORMAT.DISPLAY(Y.DATE2,Y.DATE2.FMT,'','')
        Y.DATE = Y.DATE1.FMT:' ':Y.DATE2.FMT
    END

    BEGIN CASE
        CASE Y.DATE NE '' AND Y.INS.TYPE EQ '' AND Y.CMPNY.CODE EQ ''
            Y.CRITERIA = 'FECHA - ':Y.DATE
        CASE Y.DATE EQ '' AND Y.INS.TYPE NE '' AND Y.CMPNY.CODE EQ ''
            Y.CRITERIA = 'TIPO DE INVERSION - ':Y.INS.TYPE
        CASE Y.DATE EQ '' AND Y.INS.TYPE EQ '' AND Y.CMPNY.CODE NE ''
            Y.CRITERIA = 'AGENCIA - ':Y.CMPNY.CODE
        CASE Y.DATE NE '' AND Y.INS.TYPE NE '' AND Y.CMPNY.CODE EQ ''
            Y.CRITERIA = 'FECHA - ':Y.DATE:','
            Y.CRITERIA := 'TIPO DE INVERSION - ':Y.INS.TYPE
        CASE Y.DATE NE '' AND Y.INS.TYPE EQ '' AND Y.CMPNY.CODE NE ''
            Y.CRITERIA = 'FECHA - ':Y.DATE:','
            Y.CRITERIA := 'AGENCIA - ':Y.CMPNY.CODE
        CASE Y.DATE EQ '' AND Y.INS.TYPE NE '' AND Y.CMPNY.CODE NE ''
            Y.CRITERIA = 'TIPO DE INVERSION - ':Y.INS.TYPE:','
            Y.CRITERIA := 'AGENCIA - ':Y.CMPNY.CODE:' '
        CASE Y.DATE NE '' AND Y.INS.TYPE NE '' AND Y.CMPNY.CODE NE ''
            Y.CRITERIA = 'FECHA - ':Y.DATE:','
            Y.CRITERIA := 'TIPO DE INVERSION - ':Y.INS.TYPE:','
            Y.CRITERIA := 'AGENCIA - ':Y.CMPNY.CODE
        CASE 1
            Y.CRITERIA = 'ALL'
    END CASE
*PACS00260039-end

    O.DATA = Y.CRITERIA

RETURN

*--------------------------------------------------------------------------------------------------------
END       ;* End of program
