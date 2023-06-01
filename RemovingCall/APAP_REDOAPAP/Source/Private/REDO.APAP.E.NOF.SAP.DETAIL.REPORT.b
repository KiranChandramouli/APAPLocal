* @ValidationCode : MjoxNTIyMzQ1OTI6Q3AxMjUyOjE2ODQ4MzYwMzk1Njc6SVRTUzotMTotMTo0MDQ6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 404
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.E.NOF.SAP.DETAIL.REPORT(Y.OUT.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.E.NOF.INVST.PROVISIONING
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.E.NOF.INVST.PROVISIONING is a no-file enquiry routine for the enquiry
*                    REDO.APAP.ENQ.INVST.PROVISIONING, the routine based on the selection criteria
*                    selects the records from REDO.H.CUSTOMER.PROVISION and displays the processed records
*Linked With       : Enquiry - REDO.APAP.ENQ.INVST.PROVISIONING
*In  Parameter     : NA
*Out Parameter     : Y.OUT.ARRAY - Final list of records to be displayed
*Files  Used       : REDO.GL.H.EXTRACT.PARAMETER             As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date                 Who                     Reference                  Description
*   ------               ------                  -------------               -------------
* 28 Oct 2010        Shiva Prasad Y          ODR-2009-12-0294 C.12          Initial Creation
* 03 Jun 2011        Pradeep S               PACS00072689                   Changes in creating Enquiry report for both GL & PL
*19 JUN  2011        Prabhu N                PACS00032519                   Decryption added for the file
* 03-10-2011         PRABHU N                PACS00032519                   3DES ENCRYPTION
* Date                   who                   Reference              
* 05-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION FM TO @FM AND ! TO *
* 05-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.GL.H.EXTRACT.PARAMETER
    $INSERT JBC.h
    $INSERT I_F.REDO.INTERFACE.PARAM
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
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
    END

    Y.GIT.ID = FIELD(Y.ENQ.VALUE,'|',1)
    Y.FILE.NAME = FIELD(Y.ENQ.VALUE,'|',2)

    LOCATE Y.GIT.ID IN R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.GIT.ROUTINE,1> SETTING Y.GIT.POS ELSE
        RETURN
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


    LOOP
        REMOVE Y.FILE.REC FROM R.FILE.DATA SETTING Y.REC.POS
    WHILE Y.FILE.REC : Y.REC.POS
        R.RETURN.MESSAGE=Y.FILE.REC
        GOSUB INITIALIZE.DECRYPT
        GOSUB OPEN.FILES.DECRYPT
        GOSUB PROCESS.DECRYPT
        Y.FILE.REC= Y.RECORD.LINE

        Y.COMP    = FIELD(Y.FILE.REC,',',2)
        Y.COND.KEY= FIELD(Y.FILE.REC,',',18)
        Y.CCY     = FIELD(Y.FILE.REC,',',7)

        Y.SORT.VAL = Y.COMP:Y.COND.KEY:Y.CCY
        Y.REC.VAL.LIST<-1> = Y.FILE.REC:@FM:Y.SORT.VAL
        Y.SORT.LIST<-1> = Y.SORT.VAL

    REPEAT

    Y.SORT.LIST = SORT(Y.SORT.LIST)



    LOOP
        REMOVE Y.SORTED.VAL FROM Y.SORT.LIST SETTING Y.SORT.POS
    WHILE Y.SORTED.VAL : Y.SORT.POS
        LOCATE Y.SORTED.VAL IN Y.REC.VAL.LIST SETTING Y.LOC.POS THEN
            Y.FINAL.REC<-1> = Y.REC.VAL.LIST<Y.LOC.POS-1>
            DEL Y.REC.VAL.LIST<Y.LOC.POS>
            DEL Y.REC.VAL.LIST<Y.LOC.POS-1>
        END
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
************
GET.DETAILS:
************
    LOOP
        REMOVE Y.DATA.REC FROM Y.FINAL.REC SETTING Y.DATA.POS
    WHILE Y.DATA.REC : Y.DATA.POS
        GOSUB GET.DETAILS.PART
    REPEAT

RETURN

*-----------------------
GET.DETAILS.PART:
*-----------------------

    Y.CLOSE.DATE  = FIELD(Y.DATA.REC,',',1)
    GOSUB FMT.CLOSE.DATE
    Y.VALUE.DATE  =FIELD(Y.DATA.REC,',',3)
    Y.CLOSE.DATE.TEMP=Y.CLOSE.DATE
    Y.CLOSE.DATE  = Y.VALUE.DATE
    IF Y.CLOSE.DATE THEN
        GOSUB FMT.CLOSE.DATE
    END
    Y.VALUE.DATE=Y.CLOSE.DATE
    Y.CLOSE.DATE=Y.CLOSE.DATE.TEMP
    Y.AGENCY      = FIELD(Y.DATA.REC,',',2)
    Y.COST.CENTRE = FIELD(Y.DATA.REC,',',4)
    Y.PROD.CATEG  = FIELD(Y.DATA.REC,',',5)
    Y.PROD.ACC.NO = FIELD(Y.DATA.REC,',',6)
    Y.CLIENT.NO   = FIELD(Y.DATA.REC,',',7)
    Y.CLIENT.ID   = FIELD(Y.DATA.REC,',',8)
    Y.CLIENT.TYPE = FIELD(Y.DATA.REC,',',9)
    Y.REC.CCY     = FIELD(Y.DATA.REC,',',10)
    Y.TRANS.CODE  = FIELD(Y.DATA.REC,',',11)
    Y.TRANS.DESC  = FIELD(Y.DATA.REC,',',12)
*        Y.TRANS.VAL   = FIELD(Y.DATA.REC,',',13)
*        Y.DB.CR.IND   = FIELD(Y.DATA.REC,',',14)
    Y.EX.RATE=FIELD(Y.DATA.REC,',',13)
    IF Y.EX.RATE THEN
        Y.EX.RATE=FMT(Y.EX.RATE,5)
    END
    Y.DB.LCL=FIELD(Y.DATA.REC,',',14)
    IF Y.DB.LCL THEN
        Y.DB.LCL=ABS(Y.DB.LCL)
    END
    Y.CR.LCL=FIELD(Y.DATA.REC,',',15)
    Y.DB.FCY=FIELD(Y.DATA.REC,',',16)
    IF Y.DB.FCY THEN
        Y.DB.FCY=ABS(Y.DB.FCY)
    END
    Y.CR.FCY=FIELD(Y.DATA.REC,',',17)
    Y.COND.KEY    = FIELD(Y.DATA.REC,',',18)
    Y.ACC.REC     = FIELD(Y.DATA.REC,',',19)
    Y.SIB.ACC     = FIELD(Y.DATA.REC,',',20)
    Y.USER.NAME=FIELD(Y.DATA.REC,',',21)
    Y.OUT.ARRAY<-1> = Y.CLOSE.DATE:'*':Y.AGENCY:'*':Y.VALUE.DATE:'*':Y.COST.CENTRE:'*':Y.PROD.CATEG:'*':Y.PROD.ACC.NO:'*':Y.CLIENT.NO:'*':Y.CLIENT.ID:'*':Y.CLIENT.TYPE:'*'
    Y.OUT.ARRAY    := Y.REC.CCY:'*':Y.TRANS.CODE:'*':Y.TRANS.DESC:'*':Y.EX.RATE:'*':Y.DB.LCL:'*':Y.CR.LCL:'*':Y.DB.FCY:'*':Y.CR.FCY:'*':Y.COND.KEY:'*':Y.ACC.REC:'*':Y.SIB.ACC:'*':Y.USER.NAME

RETURN
*--------------------------------------------------------------------------------------------------------
***************
FMT.CLOSE.DATE:
***************
    Y.YEAR  = Y.CLOSE.DATE[1,4]
    Y.MONTH = Y.CLOSE.DATE[5,2]
    Y.DAY   = Y.CLOSE.DATE[2]
    Y.CLOSE.DATE = Y.MONTH:'/':Y.DAY:'/':Y.YEAR

RETURN
*--------------------------------------------------------------------------------------------------------
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
    yLine = R.RETURN.MESSAGE

RETURN
*************************
PROCESS.DECRYPT:
*************************
*PACS00032519-S/E    ;*R22 AUTO CONVERSTION ! TO *
    IF R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.ENCRIPTATION> EQ 'SI' THEN
*  yLine = DECRYPT(R.RETURN.MESSAGE,yEncripKey,JBASE_CRYPT_DES_BASE64) ;*R22 AUTO CONVERSTION ! TO *

*yLine = DECRYPT(R.RETURN.MESSAGE,yEncripKey,JBASE_CRYPT_3DES_BASE64) ;*R22 AUTO CONVERSTION ! TO *
    END ELSE
        yLine = R.RETURN.MESSAGE
    END

    Y.RECORD.LINE=yLine
RETURN
END       ;* ENd of Program
