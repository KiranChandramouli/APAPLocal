* @ValidationCode : MjoxMDQxOTY3MDA4OkNwMTI1MjoxNjg0ODM2MDM5ODk4OklUU1M6LTE6LTE6NDkyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 492
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.E.NOF.SAP.GL.RPT(Y.OUT.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.E.NOF.SAP.GL.RPT
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.E.NOF.SAP.GL.RPT is a no-file enquiry routine for the enquiry
*                    REDO.APAP.E.NOF.SAP.GL.RPT, the routine based on the selection criteria
*                    selects the records from REDO.H.CUSTOMER.PROVISION and displays the processed records
*Linked With       : Enquiry - REDO.E.NOF.SAP.GL.RPT
*In  Parameter     : NA
*Out Parameter     : Y.OUT.ARRAY - Final list of records to be displayed
*Files  Used       : REDO.GL.H.EXTRACT.PARAMETER             As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date                 Who                     Reference                  Description
*   ------               ------                  -------------               -------------
* 07-08-2012           GANESH R                 PACS00208725                3DES ENCRYPTION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   F.READ to CACHE.READ , FM to @FM , ++ to +=
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------


*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.GL.H.EXTRACT.PARAMETER
    $INSERT JBC.h
    $INSERT I_F.REDO.INTERFACE.PARAM
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    Y.OUT.ARRAY          = ''
    Y.REC.TYPE           = ''
    Y.TXN.TYPE           = ''
    Y.ACCT               = ''
    Y.NCT                = ''
    Y.REVAL              = ''
    Y.CURRENCY           = ''
    Y.DEBIT.AMT          = ''
    Y.DEBIT.FCY.AMT      = ''
    Y.CREDIT.AMT         = ''
    Y.CREDIT.FCY.AMT     = ''
    Y.COSTO.VAL          = ''
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
    FN.REDO.GL.H.EXTRACT.PARAMETER = 'F.REDO.GL.H.EXTRACT.PARAMETER'
    F.REDO.GL.H.EXTRACT.PARAMETER = ''
    CALL OPF(FN.REDO.GL.H.EXTRACT.PARAMETER,F.REDO.GL.H.EXTRACT.PARAMETER)

    FN.VAL.COMPANY = 'F.COMPANY'
    F.VAL.COMPANY  = ''
    CALL OPF(FN.VAL.COMPANY,F.VAL.COMPANY)

    LOC.APPLICATION = 'COMPANY'
    LOC.FIELDS      = 'L.CO.EXT.GL.CC'
    LOC.POS         = ''
    CALL MULTI.GET.LOC.REF(LOC.APPLICATION,LOC.FIELDS,LOC.POS)
    Y.LOC.CODE.POS = LOC.POS<1,1>

    SEL.CMD = 'SELECT ':FN.VAL.COMPANY
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.ERR)
    Y.CO.INIT = 1
    Y.COMP.ID.LIST = ''
    Y.CO.NAME.LIST = ''
    Y.CO.CODE.LIST = ''
    LOOP
        REMOVE Y.COMP.ID FROM SEL.LIST SETTING Y.COMP.POS
    WHILE Y.CO.INIT LE NO.OF.REC
        R.COMP = ''
        CALL CACHE.READ(FN.VAL.COMPANY, Y.COMP.ID, R.COMP, COMP.ERR) ;*R22 AUTO CODE CONVERSION
        IF R.COMP THEN
            Y.COMP.ID.LIST<-1> = Y.COMP.ID
            Y.CO.NAME.LIST<-1> = R.COMP<EB.COM.COMPANY.NAME>
            Y.CO.CODE.LIST<-1> = R.COMP<EB.COM.LOCAL.REF,Y.LOC.CODE.POS>
            Y.CO.INIT += 1  ;*R22 AUTO CODE CONVERSION
        END
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    REDO.GL.H.EXTRACT.PARAMETER.ID = 'SYSTEM'
    GOSUB READ.REDO.GL.H.EXTRACT.PARAMETER

*PACS00072689 - S
    LOCATE 'FILE.NAME' IN D.FIELDS<1> SETTING Y.FILE.POS THEN
        Y.ENQ.VALUE = D.RANGE.AND.VALUE<Y.FILE.POS>
        Y.CLASS = 'FILE NAME :':Y.ENQ.VALUE
    END

    Y.GIT.ID = FIELD(Y.ENQ.VALUE,'|',1)
    Y.FILE.NAME = FIELD(Y.ENQ.VALUE,'|',2)

    LOCATE Y.GIT.ID IN R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.GIT.ROUTINE,1> SETTING Y.GIT.POS ELSE
        RETURN
    END
    IF Y.GIT.ID NE 'SAP.NORMAL.EXTRACT' THEN
        ENQ.ERROR = 'EB-REDO.SAP.ENQ.ERROR'
    END
    LOCATE 'SAP.NORMAL.EXTRACT' IN R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.GIT.ROUTINE,1> SETTING Y.POS1 THEN
        Y.EXTRACT.NAME = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.EXTRACT.NAME,Y.POS1>
        IF Y.EXTRACT.NAME NE Y.FILE.NAME[1,LEN(Y.EXTRACT.NAME)] THEN
            ENQ.ERROR = 'EB-REDO.SAP.ENQ.ERROR'
        END
    END

    Y.FILE.PATH = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.EXTRACT.OUT.PATH,Y.GIT.POS>

    OPEN '',Y.FILE.PATH TO F.FILE.PATH THEN

    END

    READ R.FILE.DATA FROM F.FILE.PATH, Y.FILE.NAME ELSE

        RETURN
    END

*PACS00072689 - E

    CRLF=CHARX(013):CHARX(254)
    CHANGE CRLF TO @FM IN R.FILE.DATA
    CRLF=CHARX(013):CHARX(010)
    CHANGE CRLF TO @FM IN R.FILE.DATA
    GOSUB GET.SORTED.RECORDS
    GOSUB GET.DETAILS

RETURN
*--------------------------------------------------------------------------------------------------------
*******************
GET.SORTED.RECORDS:
*******************
    Y.REC.VAL.LIST = ''
    Y.SORT.LIST    = ''
    Y.FINAL.REC    = ''
    Y.UNSORT.ARRAY = R.FILE.DATA
    LOOP
        REMOVE Y.FILE.REC FROM R.FILE.DATA SETTING Y.REC.POS
    WHILE Y.FILE.REC : Y.REC.POS
        R.RETURN.MESSAGE=Y.FILE.REC
        GOSUB INITIALIZE.DECRYPT
        GOSUB OPEN.FILES.DECRYPT
        GOSUB PROCESS.DECRYPT
        Y.FILE.REC.SORT<-1> = Y.RECORD.LINE
    REPEAT
    Y.UNSORT.ARRAY=Y.FILE.REC.SORT

RETURN
*--------------------------------------------------------------------------------------------------------
************
GET.DETAILS:
************

    LOOP
        REMOVE Y.DATA.REC FROM Y.UNSORT.ARRAY SETTING Y.DATA.POS
    WHILE Y.DATA.REC : Y.DATA.POS
        Y.GET.REC.TYPE = FIELD(Y.DATA.REC,',',1)
        IF Y.GET.REC.TYPE NE '0' THEN
            GOSUB CHECK.REC.TYPE
            GOSUB FORM.OUT.ARRAY
        END
    REPEAT
RETURN

CHECK.REC.TYPE:

    IF Y.GET.REC.TYPE EQ '1' THEN
        Y.LOC.COM.CODE      = ''
        Y.LOC.COM.CODE      = FIELD(Y.DATA.REC,',',2)
        LOCATE Y.LOC.COM.CODE IN Y.CO.CODE.LIST SETTING Y.LOC.CO.POS THEN
            Y.COMP.DESC = Y.CO.NAME.LIST<Y.LOC.CO.POS>
        END
        Y.REC.TYPE      = FIELD(Y.DATA.REC,',',2):'-':Y.COMP.DESC
        Y.TXN.TYPE      = ''
        Y.ACCT          = ''
        Y.NCT           = ''
        Y.CURRENCY      = ''
        Y.DEBIT.AMT     = ''
        Y.DEBIT.FCY.AMT = ''
        Y.CREDIT.AMT    = ''
        Y.CREDIT.FCY.AMT= ''
        Y.COSTO.VAL     = ''
        Y.BRK.CHANGE    = Y.LOC.COM.CODE
    END ELSE
        GOSUB GET.SUB.DETAILS
    END

RETURN
*-------------------------------------------------------------------------------------------
GET.SUB.DETAILS:

    Y.REC.TYPE         = ''
    Y.TXN.TYPE         = FIELD(Y.DATA.REC,',',2)
    Y.ACCT             = FIELD(Y.DATA.REC,',',3)
    Y.NCT              = FIELD(Y.DATA.REC,',',8)
    Y.REVAL            = ''
    Y.CURRENCY         = FIELD(Y.DATA.REC,',',5)

    Y.AMOUNT           = ''
    Y.AMOUNT           = FIELD(Y.DATA.REC,',',6)
    VAL.DEBIT.AMT      = Y.AMOUNT


    Y.AMOUNT           = ''
    Y.AMOUNT           = FIELD(Y.DATA.REC,',',7)
    VAL.CREDIT.AMT     = Y.AMOUNT


    Y.COSTO.VAL        = FIELD(Y.DATA.REC,',',4)
    Y.BRK.CHANGE       = Y.LOC.COM.CODE

    IF FIELD(Y.DATA.REC,',',2) EQ '40' AND FIELD(Y.DATA.REC,',',5) EQ LCCY THEN
        Y.DEBIT.AMT      = VAL.DEBIT.AMT/100          ;* Last 2 digits are decimal
        Y.DEBIT.FCY.AMT  = ''
        Y.CREDIT.AMT     = ''
        Y.CREDIT.FCY.AMT = ''
    END
    IF FIELD(Y.DATA.REC,',',2) EQ '50' AND FIELD(Y.DATA.REC,',',5) EQ LCCY THEN
        Y.DEBIT.AMT      = ''
        Y.DEBIT.FCY.AMT  = ''
        Y.CREDIT.AMT     = VAL.DEBIT.AMT/100          ;* Last 2 digits are decimal
        Y.CREDIT.FCY.AMT = ''
    END
    IF FIELD(Y.DATA.REC,',',2) EQ '40' AND FIELD(Y.DATA.REC,',',5) NE LCCY THEN
        Y.DEBIT.AMT      = VAL.DEBIT.AMT/100          ;* Last 2 digits are decimal
        Y.DEBIT.FCY.AMT  = VAL.CREDIT.AMT/100         ;* Last 2 digits are decimal
        Y.CREDIT.AMT     = ''
        Y.CREDIT.FCY.AMT = ''
    END
    IF FIELD(Y.DATA.REC,',',2) EQ '50' AND FIELD(Y.DATA.REC,',',5) NE LCCY THEN
        Y.DEBIT.AMT      = ''
        Y.DEBIT.FCY.AMT  = ''
        Y.CREDIT.AMT     = VAL.DEBIT.AMT/100          ;* Last 2 digits are decimal
        Y.CREDIT.FCY.AMT = VAL.CREDIT.AMT/100         ;* Last 2 digits are decimal
    END

RETURN
*------------------------------------------------------------------------------------------
FORM.OUT.ARRAY:
    GOSUB FMT.CLOSE.DATE
    IF Y.OUT.ARRAY EQ '' THEN
        Y.OUT.ARRAY = Y.REC.TYPE:'*':Y.TXN.TYPE:'*':Y.ACCT:'*':Y.NCT:'*':Y.CURRENCY:'*':Y.DEBIT.AMT:'*':Y.DEBIT.FCY.AMT:'*':Y.CREDIT.AMT:'*':Y.CREDIT.FCY.AMT:'*':Y.COSTO.VAL:'*':Y.BRK.CHANGE:'*':Y.CLOSE.DATE:'*':Y.CLASS
    END ELSE
        Y.OUT.ARRAY<-1> = Y.REC.TYPE:'*':Y.TXN.TYPE:'*':Y.ACCT:'*':Y.NCT:'*':Y.CURRENCY:'*':Y.DEBIT.AMT:'*':Y.DEBIT.FCY.AMT:'*':Y.CREDIT.AMT:'*':Y.CREDIT.FCY.AMT:'*':Y.COSTO.VAL:'*':Y.BRK.CHANGE:'*':Y.CLOSE.DATE:'*':Y.CLASS
    END
RETURN
*-------------------------------------------------------------------------------------------
***************
FMT.CLOSE.DATE:
***************
    Y.CLOSE.DATE = TODAY
    Y.YEAR  = Y.CLOSE.DATE[1,4]
    Y.MONTH = Y.CLOSE.DATE[5,2]
    Y.DAY   = Y.CLOSE.DATE[2]
    Y.CLOSE.DATE = Y.MONTH:'/':Y.DAY:'/':Y.YEAR

RETURN
*-----------------------------------------------------------------------------------------------
*********************************
READ.REDO.GL.H.EXTRACT.PARAMETER:
*********************************
* In this para of the code, file REDO.GL.H.EXTRACT.PARAMETER is read
    R.REDO.GL.H.EXTRACT.PARAMETER  = ''
    REDO.GL.H.EXTRACT.PARAMETER.ER = ''
    CALL CACHE.READ(FN.REDO.GL.H.EXTRACT.PARAMETER,REDO.GL.H.EXTRACT.PARAMETER.ID,R.REDO.GL.H.EXTRACT.PARAMETER,REDO.GL.H.EXTRACT.PARAMETER.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------
*************************
INITIALIZE.DECRYPT:
*************************
    Y.ERR = ''
    Y.PARAM.ID = "DES333"
    FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
    F.REDO.INTERFACE.PARAM = ""
    R.REDO.INTERFACE.PARAM = ""
    GOAHEAD = ''
RETURN
*************************
OPEN.FILES.DECRYPT:
*************************
    CALL OPF(FN.REDO.INTERFACE.PARAM, F.REDO.INTERFACE.PARAM)
    CALL F.READ(FN.REDO.INTERFACE.PARAM, Y.PARAM.ID, R.REDO.INTERFACE.PARAM, F.REDO.INTERFACE.PARAM, Y.ERR)
    IF NOT(R.REDO.INTERFACE.PARAM) THEN
        RETURN
    END
    GOAHEAD = 'TRUE'
    yEncripKey = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.ENCRIP.KEY>
    yEncripKey= DECRYPT(yEncripKey,Y.PARAM.ID,JBASE_CRYPT_3DES_BASE64)

    yLine = R.RETURN.MESSAGE

RETURN
*************************
PROCESS.DECRYPT:
*************************
*PACS00032519-S/E
    IF R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.ENCRIPTATION> EQ 'SI' THEN
*  yLine = DECRYPT(R.RETURN.MESSAGE,yEncripKey,JBASE_CRYPT_DES_BASE64)

        yLine = DECRYPT(R.RETURN.MESSAGE,yEncripKey,JBASE_CRYPT_3DES_BASE64)
    END ELSE
        yLine = R.RETURN.MESSAGE
    END

    Y.RECORD.LINE=yLine
RETURN
END       ;* ENd of Program
