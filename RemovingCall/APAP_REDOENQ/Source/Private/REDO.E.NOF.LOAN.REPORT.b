* @ValidationCode : MjotOTY2NDEyMTgyOkNwMTI1MjoxNjg0ODUxOTc4MDQ1OklUU1M6LTE6LTE6NjAyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 19:56:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 602
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.NOF.LOAN.REPORT(Y.FINAL.ARRAY)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : TAM.E.NOF.LOAN.REPORT
*--------------------------------------------------------------------------------------------------------
*Description  : This is a no file enquiry routine for displaying the loan disbursement itemization
*Linked With  : Enquiry REDO.E.NOF.LOAN.REPORT
*In Parameter : N/A
*Out Parameter: LN.ARRAY
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------                -------------            -------------
* 19th Aug 2010    SWAMINATHAN.S.R       ODR-2010-03-0135       Initial Creation
*
* 17-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM, VM to @VM, SM to @SM, ++ to +=
* 17-APR-2023      Harishvikram C   Manual R22 conversion      CALL routine format modified
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.COMPANY
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.AA.DISBURSE.METHOD
    $INSERT I_F.REDO.FC.FORM.DISB
    $USING APAP.TAM
*---------------------------------------------------------------------------------------------------------


    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN
*---------------------------------------------------------------------------------------------------------
OPEN.FILES:
*---------------------------------------------------------------------------------------------------------
* Here we will open all required files.

    FN.AA.ARRANGEMENT = "F.AA.ARRANGEMENT"
    F.AA.ARRANGEMENT  = ""
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.REDO.FC.FORM.DISB = "F.REDO.FC.FORM.DISB"
    F.REDO.FC.FORM.DISB  = ""
    CALL OPF(FN.REDO.FC.FORM.DISB,F.REDO.FC.FORM.DISB)

    FN.FUNDS.TRANSFER = "F.FUNDS.TRANSFER"
    F.FUNDS.TRANSFER  = ""
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER$HIS = "F.FUNDS.TRANSFER$HIS"
    F.FUNDS.TRANSFER$HIS  = ""
    CALL OPF(FN.FUNDS.TRANSFER$HIS,F.FUNDS.TRANSFER$HIS)

    LOC.REF.APPLICATION   = "AA.PRD.DES.CUSTOMER":@FM:"FUNDS.TRANSFER"
    LOC.REF.FIELDS        = 'L.AA.CAMP.TY':@FM:'L.ACTUAL.VERSIO'
    LOC.REF.POS           = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AA.CAMP.TY      = LOC.REF.POS<1,1>
    POS.L.ACTUAL.VERSIO   = LOC.REF.POS<2,1>

* Here we will read the disb table to get the description.
    R.DISB.TYPES  = ""
    Y.FINAL.ARRAY = ""
    SEL.CMD.VER = "SELECT ":FN.REDO.FC.FORM.DISB
    CALL EB.READLIST(SEL.CMD.VER,SEL.LIST.VER,'',SEL.NOR.VER,SEL.RET)
    LOOP
        REMOVE Y.DISB.ID FROM SEL.LIST.VER SETTING VER.POS
    WHILE Y.DISB.ID:VER.POS
        CALL F.READ(FN.REDO.FC.FORM.DISB,Y.DISB.ID,R.REDO.FC.FORM.DISB,F.REDO.FC.FORM.DISB,DISB.ERR)
        R.DISB.TYPES<1,-1> = R.REDO.FC.FORM.DISB<FC.PR.DESCRIPCION>:@VM:R.REDO.FC.FORM.DISB<FC.PR.DESCRIPCION>
        R.DISB.TYPES<2,-1> = R.REDO.FC.FORM.DISB<FC.PR.NAME.VRN>:@VM:R.REDO.FC.FORM.DISB<FC.PR.NAME.PART.VRN>

    REPEAT

RETURN
*---------------------------------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------------------------------
* Main process begins....

    LOCATE "DISB.DATE" IN D.FIELDS<1> SETTING POS.FLD THEN
        Y.DISB.VALUE   = D.RANGE.AND.VALUE<POS.FLD>
        Y.DISB.OPERAND = D.LOGICAL.OPERANDS<POS.FLD>
        Y.DISB.FIELDS  = D.FIELDS<POS.FLD>
        GOSUB CHECK.OPERAND.COND
        CHANGE @SM TO @VM IN Y.DISB.VALUE
        DEL D.RANGE.AND.VALUE<POS.FLD>
        DEL D.LOGICAL.OPERANDS<POS.FLD>
        DEL D.FIELDS<POS.FLD>
    END ELSE
        Y.DISB.VALUE   = ""
        Y.DISB.OPERAND = ""
        Y.DISB.FIELDS  = ""
    END

    IF D.FIELDS NE "" THEN
        LOCATE "LOAN.REP" IN D.FIELDS<1> SETTING DEL.POS THEN
            DEL D.FIELDS<DEL.POS>
            DEL D.RANGE.AND.VALUE<DEL.POS>
            DEL D.LOGICAL.OPERANDS<DEL.POS>
        END
        FILE.NAME = FN.AA.ARRANGEMENT
        D.RANGE.AND.VALUE<-1> = "LENDING" ; D.LOGICAL.OPERANDS<-1> = 1 ; D.FIELDS<-1> = "PRODUCT.LINE"
        CALL APAP.REDOENQ.redoEFormSelStmt(FILE.NAME, '', '', SEL.AA.ARR.CMD) ;*R22 Auto conversion
        SEL.AA.ARR.CMD := " AND WITH ARR.STATUS NE AUTH AND WITH ARR.STATUS NE UNAUTH"
        CALL EB.READLIST(SEL.AA.ARR.CMD,AA.ARR.ID.LST,'',NO.OF.REC.ARR,SEL.ERR)

    END ELSE

        SEL.AA.ARR.CMD = "SELECT ":FN.AA.ARRANGEMENT:" WITH ARR.STATUS EQ 'CURRENT' 'EXPIRED' 'MATURED' AND PRODUCT.LINE EQ 'LENDING'"
        CALL EB.READLIST(SEL.AA.ARR.CMD,AA.ARR.ID.LST,'',NO.OF.REC.ARR,SEL.ERR)

    END
    IF AA.ARR.ID.LST AND Y.DISB.FIELDS THEN
        GOSUB GET.DETAILS.DISB
    END
    IF AA.ARR.ID.LST AND Y.DISB.FIELDS EQ "" THEN
        GOSUB GET.DETAILS.WITHOUT.DISB
    END

RETURN
*--------------------------------------------
CHECK.OPERAND.COND:
*--------------------------------------------
* Here selection criteria is validated against the operand

    IF Y.DISB.OPERAND EQ 1 THEN
        Y.VALUE.CNT = DCOUNT(Y.DISB.VALUE,@SM)
        IF Y.VALUE.CNT GT 1 THEN
            ENQ.ERROR = "Only one value allowed for this operand - ":Y.DISB.FIELDS
            GOSUB END1
        END
    END
    IF Y.DISB.OPERAND EQ 2 THEN
        Y.VALUE.CNT = DCOUNT(Y.DISB.VALUE,@SM)
        IF Y.VALUE.CNT NE 2 THEN
            ENQ.ERROR = "Two values needs to be entered for this operand - ":Y.DISB.FIELDS
            GOSUB END1
        END
    END

RETURN
*---------------------------------------------------------------------------------
GET.DETAILS.DISB:
*---------------------------------------------------------------------------------

    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE NO.OF.REC.ARR
        Y.AA.ID = AA.ARR.ID.LST<Y.VAR1>
        Y.SKIP.FLAG = "YES"
        CALL APAP.TAM.redoGetDisbursementDetails(Y.AA.ID,R.DISB.DETAILS,Y.COMMITED.AMT,Y.PEND.DISB) ;*;*R22 Manual conversion
        GOSUB VALIDATE.DISB.SELECTION
        IF Y.SKIP.FLAG EQ "NO" THEN
            GOSUB GET.REMAINING.DETAILS
        END
        Y.VAR1 += 1
    REPEAT

RETURN
*---------------------------------------------------------------------------------
GET.DETAILS.WITHOUT.DISB:
*---------------------------------------------------------------------------------
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE NO.OF.REC.ARR
        Y.AA.ID = AA.ARR.ID.LST<Y.VAR1>
        CALL APAP.TAM.redoGetDisbursementDetails(Y.AA.ID,R.DISB.DETAILS,Y.COMMITED.AMT,Y.PEND.DISB);*;*R22 Manual conversion
        GOSUB GET.REMAINING.DETAILS
        Y.VAR1 += 1
    REPEAT

RETURN
*---------------------------------------------------------------------------------
VALIDATE.DISB.SELECTION:
*---------------------------------------------------------------------------------

    Y.DISB.DATES = R.DISB.DETAILS<1>
    IF Y.DISB.OPERAND EQ 1 THEN
        GOSUB CHECK.DISB.OPERAND.EQ
    END
    IF Y.DISB.OPERAND EQ 2 THEN
        GOSUB CHECK.DISB.OPERAND.RG
    END

RETURN
*---------------------------------------------------------------------------------
CHECK.DISB.OPERAND.EQ:
*---------------------------------------------------------------------------------

    IF Y.DISB.VALUE MATCHES Y.DISB.DATES THEN
        Y.SKIP.FLAG  = "NO"
        Y.DISB.DATES = ""         ;* To break the loop.
    END

RETURN
*---------------------------------------------------------------------------------
CHECK.DISB.OPERAND.RG:
*---------------------------------------------------------------------------------
    LOOP
        REMOVE Y.DIS.DATE FROM Y.DISB.DATES SETTING DIS.POS
    WHILE Y.DIS.DATE:DIS.POS
        IF Y.DIS.DATE GE Y.DISB.VALUE<1,1> AND Y.DIS.DATE LE Y.DISB.VALUE<1,2> THEN
            Y.SKIP.FLAG  = "NO"
            Y.DISB.DATES = ""       ;* To break the loop.
        END
    REPEAT

RETURN
*---------------------------------------------------------------------------------
GET.REMAINING.DETAILS:
*---------------------------------------------------------------------------------

    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
    Y.LOAN.NO      = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    Y.CO.CODE      = R.AA.ARRANGEMENT<AA.ARR.CO.CODE>
    Y.PRODUCT      = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
    Y.PRODUCT.GROUP = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>


    R.CONDITION.ACCOUNT = ""
    CALL APAP.TAM.redoCrrGetConditions(Y.AA.ID,"","ACCOUNT","",R.CONDITION.ACCOUNT,"") ;*R22 Manual conversion
    Y.ALT.ID = R.CONDITION.ACCOUNT<AA.AC.ALT.ID>
    R.CONDITION.CUSTOMER = ""
    CALL APAP.TAM.redoCrrGetConditions(Y.AA.ID,"","CUSTOMER","",R.CONDITION.CUSTOMER,"") ;*R22 Manual conversion
    Y.CAMP.TYPE = R.CONDITION.CUSTOMER<AA.CUS.LOCAL.REF,POS.L.AA.CAMP.TY>

    Y.COMMITED.AMOUNT  = Y.COMMITED.AMT
    Y.FINAL.DISB.DATES = R.DISB.DETAILS<1>
    Y.FINAL.DISB.AMT   = R.DISB.DETAILS<2>
    GOSUB GET.DISB.DESCRIPTION
    Y.FINAL.ARRAY<-1> = Y.LOAN.NO:"*":Y.ALT.ID:"*":Y.CO.CODE:"*":Y.PRODUCT:"*":Y.PRODUCT.GROUP:"*":Y.CAMP.TYPE:"*":Y.COMMITED.AMOUNT:"*":Y.FINAL.DISB.DATES:"*":Y.FINAL.DISB.TYPES:"*":Y.FINAL.DISB.AMT

RETURN
*-----------------------------------------------------------------------------------
GET.DISB.DESCRIPTION:
*-----------------------------------------------------------------------------------
*Here we need to get the description of the disbursement made on loan. like cheque, cash, migrated etc.

    Y.FINAL.DISB.TYPES   = ""
    Y.DISBURSEMENT.TYPES = R.DISB.DETAILS<5>
    LOOP
        REMOVE Y.DISB.TYPE FROM Y.DISBURSEMENT.TYPES SETTING DISB.POS
    WHILE Y.DISB.TYPE:DISB.POS
        IF Y.DISB.TYPE EQ "MIGRATE" THEN
            Y.FINAL.DISB.TYPES<1,-1> = "MIGRADO"
            CONTINUE
        END
        GOSUB CHECK.FT.DESB
    REPEAT
RETURN
*-----------------
CHECK.FT.DESB:
*-----------------
    IF FIELD(Y.DISB.TYPE,"*",2) THEN      ;* If we have the FT reference then get the version name from FT.
        Y.FT.ID = FIELD(Y.DISB.TYPE,"*",2)
        CALL F.READ(FN.FUNDS.TRANSFER,Y.FT.ID,R.FT,F.FUNDS.TRANSFER,FT.ERR)
        IF R.FT THEN
            Y.ACTUAL.VERSION = R.FT<FT.LOCAL.REF,POS.L.ACTUAL.VERSIO>
            LOCATE Y.ACTUAL.VERSION IN R.DISB.TYPES<2,1> SETTING DESC.POS THEN
                Y.FINAL.DISB.TYPES<1,-1> = R.DISB.TYPES<1,DESC.POS>
            END ELSE
                Y.FINAL.DISB.TYPES<1,-1> = "DESEMBOLSO DE PRESTAMO" ;* If we not able to find the description then default desb.
            END
        END ELSE
            CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER$HIS,Y.FT.ID,R.FT,FT.ERR)
            IF R.FT THEN
                Y.ACTUAL.VERSION = R.FT<FT.LOCAL.REF,POS.L.ACTUAL.VERSIO>
                LOCATE Y.ACTUAL.VERSION IN R.DISB.TYPES<2,1> SETTING DESC.POS THEN
                    Y.FINAL.DISB.TYPES<1,-1> = R.DISB.TYPES<1,DESC.POS>
                END ELSE
                    Y.FINAL.DISB.TYPES<1,-1> = "DESEMBOLSO DE PRESTAMO"
                END
            END ELSE
                Y.FINAL.DISB.TYPES<1,-1> = "DESEMBOLSO DE PRESTAMO"
            END
        END

    END ELSE
        Y.FINAL.DISB.TYPES<1,-1> = "DESEMBOLSO DE PRESTAMO"
    END

RETURN
END1:
END
