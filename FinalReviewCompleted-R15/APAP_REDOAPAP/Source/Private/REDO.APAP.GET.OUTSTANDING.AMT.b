* @ValidationCode : MjotMTY3NzYwNjY4MDpDcDEyNTI6MTY4NTU0NDEwMDMxNzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 20:11:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.GET.OUTSTANDING.AMT(Y.DATE,ARRANGEMENT.ID,Y.AMT)
*********************************************************************************************************
*Company   Name     : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.GET.OUTSTANDING.AMT
*--------------------------------------------------------------------------------------------------------
*Description       :REDO.APAP.GET.OUTSTANDING.AMT is a subroutine used to calculate the outstanding amount
*                   of an arrangement on a particular date
*Used in           :Routines REDO.APAP.AUT.CPH.OPEN, REDO.APAP.AUT.CPH.MODIFY, REDO.APAP.INP.CAP.COVER,
*                   REDO.APAP.AUT.UPD.MORTGAGE.DET and REDO.APAP.NOFILE.MG.ACCT.NO
*In  Parameter     : Y.DATE and ARRANGEMENT.ID
*Out Parameter     : Y.OUT.AMT
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  26/07/2010      Rashmitha M        ODR-2009-10-0346         Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM , ++ to +=
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.TERM.AMOUNT
    $USING APAP.TAM
    $USING APAP.AA

    GOSUB PROCESS.PARA
RETURN
*--------------------------------------------------------------------------------------------------------
************
PROCESS.PARA:
************
    IF Y.DATE EQ TODAY THEN
        GOSUB CHECK.AA.LOAN.REPORT
    END ELSE
        GOSUB CHECK.AA.DETAILS.SCHEDULE
    END
RETURN
*--------------------------------------------------------------------------------------------------------
CHECK.AA.LOAN.REPORT:
*--------------------------------------------------------------------------------------------------------

    O.DATA= ARRANGEMENT.ID
    CALL E.MB.AA.REPORT.HEADER
    Y.PRINCIPAL = FIELD(O.DATA,'*',8,1)

    Y.AMT = Y.PRINCIPAL
RETURN
*--------------------------------------------------------------------------------------------------------
CHECK.AA.DETAILS.SCHEDULE:
*--------------------------------------------------------------------------------------------------------

    ENQ.SELECTION<1,1> = 'E.AA.SCHEDULE.PROJECTOR'
    ENQ.SELECTION<2,1> = 'ARRANGEMENT.ID'
    ENQ.SELECTION<3,1> = 'EQ'
    ENQ.SELECTION<4,1> = ARRANGEMENT.ID


    CALL E.AA.SCHEDULE.PROJECTOR(Y.ENQ.OUT)
    IF Y.DATE LT FIELD(FIELD(Y.ENQ.OUT,@FM,1),'^',1,1) THEN
        GOSUB CHECK.AA.TERM.AMOUNT
        RETURN
    END

    Y.VAL.COUNT=DCOUNT(Y.ENQ.OUT,@FM)
    VAR1=1
    LOOP
    WHILE VAR1 LE Y.VAL.COUNT
        Y.REC=Y.ENQ.OUT<VAR1>
        IF Y.DATE LT FIELD(Y.REC,'^',1,1) THEN
*PACS00101744-S
*   Y.REC=Y.ENQ.OUT<VAR1-1>
*PACS00101744-E
            Y.AMT=FIELD(Y.REC,'^',7,1)
            EXIT
        END
        IF Y.DATE EQ FIELD(Y.REC,'^',1,1) THEN
            Y.AMT=FIELD(Y.REC,'^',7,1)
        END
        VAR1 += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT
    Y.AMT=ABS(Y.AMT)
RETURN
*--------------------------------------------------------------------------------------------------------
CHECK.AA.TERM.AMOUNT:
*--------------------------------------------------------------------------------------------------------

    EFF.DATE = ''
    PROP.CLASS='TERM.AMOUNT'
    PROPERTY = ''
    R.CONDITION = ''
    ERR.MSG = ''
    APAP.AA.redoCrrGetConditions(ARRANGEMENT.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
    Y.AMT=R.CONDITION<AA.AMT.AMOUNT>

RETURN
*--------------------------------------------------------------------------------------------------------
END
