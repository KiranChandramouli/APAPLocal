* @ValidationCode : MjotMTE5Nzg5OTE3ODpDcDEyNTI6MTY4MTg4NDQ3NTU0Mjphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Apr 2023 11:37:55
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
SUBROUTINE REDO.APAP.VAL.PORTFOLIO.NO
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.PORTFOLIO.NO
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a validation routine. It is used to extract the CUSOTMER number from
*                    ID.NEW and then read the file REDO.CUS.PORTFOLIO.DET with the same CUSOTMER number
*                    and get the value of PORTFOLIO.NO and assign it to this field
*Linked With       : COLLATERAL,DOC.RECEPTION
*In  Parameter     :
*Out Parameter     :
*Files  Used       : REDO.CUS.PORTFOLIO.DET      As          I-O   Mode
*                    LOCKING                     As          I-O   Mode
*                    COLLATERAL                  As          I     Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 20/05/2010    Shiva Prasad Y     ODR-2009-10-0310 B.180C      Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*19-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM
*19-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.LOCKING
    $INSERT I_F.REDO.CUS.PORTFOLIO.DET
*--------------------------------------------------------------------------------------------------------
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
    FN.REDO.CUS.PORTFOLIO.DET = 'F.REDO.CUS.PORTFOLIO.DET'
    F.REDO.CUS.PORTFOLIO.DET  = ''
    CALL OPF(FN.REDO.CUS.PORTFOLIO.DET,F.REDO.CUS.PORTFOLIO.DET)

    FN.LOCKING = 'F.LOCKING'
    F.LOCKING  = ''
    CALL OPF(FN.LOCKING,F.LOCKING)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
    IF COMI THEN
        GOSUB GET.DETAILS
    END ELSE
        GOSUB UPDATE.DETAILS
    END

RETURN
*--------------------------------------------------------------------------------------------------------
************
GET.DETAILS:
************
    CUSTOMER.ID = FIELD(ID.NEW,'.',1,1)
    REDO.CUS.PORTFOLIO.DET.ID = CUSTOMER.ID:'-':COMI
    GOSUB READ.REDO.CUS.PORTFOLIO.DET
    IF R.REDO.CUS.PORTFOLIO.DET THEN
        RETURN
    END

    SEL.CMD = "SELECT ":FN.REDO.CUS.PORTFOLIO.DET:" WITH @ID LIKE ":CUSTOMER.ID:"..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    IF NO.OF.REC THEN
        ETEXT = 'CO-PORTFOLIO.DUP':@FM:FIELD(SEL.LIST,'-',2,1)
        CALL STORE.END.ERROR
        RETURN
    END

    SEL.CMD = "SELECT ":FN.REDO.CUS.PORTFOLIO.DET:" WITH @ID LIKE ...-":COMI
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    IF NO.OF.REC THEN
        ETEXT = 'CO-PORTFOLIO.CHK'
        CALL STORE.END.ERROR
        RETURN
    END

    REDO.CUS.PORTFOLIO.DET.ID = CUSTOMER.ID:'-':COMI
    Y.LOK.CONTENT=COMI
    GOSUB WRITE.DETAILS

RETURN
*--------------------------------------------------------------------------------------------------------
***************
UPDATE.DETAILS:
***************
    GOSUB FIND.MULTI.LOCAL.REF
    CUSTOMER.ID = FIELD(ID.NEW,'.',1,1)
    SEL.CMD = "SELECT ":FN.REDO.CUS.PORTFOLIO.DET:" WITH @ID LIKE ":CUSTOMER.ID:"..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    IF NO.OF.REC THEN
        COMI = FIELD(SEL.LIST,'-',2,1)
        RETURN
    END

    LOCKING.ID = 'REDO.PORTFOLIO.NO'
    GOSUB READ.LOCKING
    Y.LOK.CONTENT = R.LOCKING<EB.LOK.CONTENT>
    IF NOT(Y.LOK.CONTENT) THEN
        Y.LOK.CONTENT = 1
    END
    GOSUB CHECK.REC

    LOOP
    WHILE NO.OF.REC NE 0
        Y.LOK.CONTENT += 1
        GOSUB CHECK.REC
    REPEAT

    COMI = Y.LOK.CONTENT
    R.LOCKING<EB.LOK.CONTENT> = Y.LOK.CONTENT
    GOSUB WRITE.LOCKING

    REDO.CUS.PORTFOLIO.DET.ID = CUSTOMER.ID:'-':Y.LOK.CONTENT
    GOSUB WRITE.DETAILS

RETURN
*--------------------------------------------------------------------------------------------------------
**************
WRITE.DETAILS:
**************
    GOSUB READ.REDO.CUS.PORTFOLIO.DET
    R.REDO.CUS.PORTFOLIO.DET<CUS.PORT.CUSTOMER.NO>  = CUSTOMER.ID
    R.REDO.CUS.PORTFOLIO.DET<CUS.PORT.PORTFOLIO.NO> = Y.LOK.CONTENT
    GOSUB WRITE.REDO.CUS.PORTFOLIO.DET

RETURN
*--------------------------------------------------------------------------------------------------------
**********
CHECK.REC:
**********
    SEL.CMD = "SELECT ":FN.REDO.CUS.PORTFOLIO.DET:" WITH @ID LIKE ...-":Y.LOK.CONTENT
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

RETURN
*--------------------------------------------------------------------------------------------------------
****************************
READ.REDO.CUS.PORTFOLIO.DET:
****************************
    R.REDO.CUS.PORTFOLIO.DET  = ''
    ER.REDO.CUS.PORTFOLIO.DET = ''
    CALL F.READ(FN.REDO.CUS.PORTFOLIO.DET,REDO.CUS.PORTFOLIO.DET.ID,R.REDO.CUS.PORTFOLIO.DET,F.REDO.CUS.PORTFOLIO.DET,ER.REDO.CUS.PORTFOLIO.DET)

RETURN
*---------------------------------------------------------------------------------------------------------------------------
*************
READ.LOCKING:
*************
    R.LOCKING  = ''
    LOCKING.ER = ''
    CALL F.READU(FN.LOCKING,LOCKING.ID,R.LOCKING,F.LOCKING,LOCKING.ER,'')

RETURN
*---------------------------------------------------------------------------------------------------------------------------
**************
WRITE.LOCKING:
**************

    WRITE R.LOCKING TO F.LOCKING,LOCKING.ID


RETURN
*---------------------------------------------------------------------------------------------------------------------------
*****************************
WRITE.REDO.CUS.PORTFOLIO.DET:
*****************************
    CALL F.WRITE(FN.REDO.CUS.PORTFOLIO.DET,REDO.CUS.PORTFOLIO.DET.ID,R.REDO.CUS.PORTFOLIO.DET)

RETURN
*---------------------------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    APPL.ARRAY = 'COLLATERAL'
    FLD.ARRAY  = 'L.CO.PORT.NO'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.CO.PORT.NO.POS  = FLD.POS<1,1>

RETURN
*---------------------------------------------------------------------------------------------------------------------------
END
