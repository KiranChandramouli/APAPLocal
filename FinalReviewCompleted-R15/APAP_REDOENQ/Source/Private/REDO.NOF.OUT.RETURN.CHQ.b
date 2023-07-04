* @ValidationCode : MjotNTIwOTE3ODA3OkNwMTI1MjoxNjg0ODUxOTg0OTExOklUU1M6LTE6LTE6Mjc1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 19:56:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 275
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.OUT.RETURN.CHQ(ENQ.DATA)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Ganesh R
*Program   Name    :REDO.NOF.OUT.RETURN.CHQ
*---------------------------------------------------------------------------------

*DESCRIPTION       :This routine is No file routine REDO.NOF.OUT.RETURN.CHQ
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 13-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM , FM to @FM  and ++ to +=
* 13-APRIL-2023      Harsha                R22 Manual Conversion - Call rtn modified
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.CLEARING.OUTWARD
    $INSERT I_F.REDO.OUTWARD.RETURN
    $USING APAP.TAM

    GOSUB INIT
    GOSUB OPEN.FILE
    GOSUB PROCESS

RETURN

*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------
*Initialisation
    DATE.VAL = ''
    ACCT.VAL = ''
    CODE.VAL = ''
    CHEQUE.VAL = ''
RETURN

*---------------------------------------------------------------------------------
OPEN.FILE:
*---------------------------------------------------------------------------------
*Opening Files

    FN.REDO.OUTWARD.RETURN = 'F.REDO.OUTWARD.RETURN'
    F.REDO.OUTWARD.RETURN = ''
    CALL OPF(FN.REDO.OUTWARD.RETURN,F.REDO.OUTWARD.RETURN)

    FN.REDO.CLEARING.OUTWARD = 'F.REDO.CLEARING.OUTWARD'
    F.REDO.CLEARING.OUTWARD = ''
    CALL OPF(FN.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD)

RETURN

*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
*Reading the Enquiry Selection Values

    Y.ENQ.FIELDS = ENQ.DATA<2>
    CHANGE @VM TO @FM IN Y.ENQ.FIELDS
    D.FIELDS=Y.ENQ.FIELDS

    Y.ENQ.OPERANDS  = ENQ.DATA<3>
    CHANGE @VM TO @FM IN Y.ENQ.OPERANDS
    D.LOGICAL.OPERANDS= Y.ENQ.OPERANDS

    Y.ENQ.VALUES  =  ENQ.DATA<4>
    CHANGE @VM TO @FM IN Y.ENQ.VALUES
    D.RANGE.AND.VALUE=Y.ENQ.VALUES


    IF D.FIELDS NE '' THEN
        FILE.NAME = FN.REDO.OUTWARD.RETURN
        APAP.TAM.redoFormFileEnqSelStmt(FILE.NAME,SEL.CMD);*R22 Manual Conversion
    END ELSE
        SEL.CMD = "SELECT ":FN.REDO.OUTWARD.RETURN
    END
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.ERR)

    VAR.COUNT = 1
    LOOP
        REMOVE OUTWARD.ID FROM SEL.LIST SETTING OUT.POS
    WHILE VAR.COUNT LE NO.OF.REC
        CALL F.READ(FN.REDO.CLEARING.OUTWARD,OUTWARD.ID,R.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD,OUTWARD.ERR)
        Y.CHECK.ID = FIELDS(OUTWARD.ID,'-',1)
        IF R.REDO.CLEARING.OUTWARD AND Y.CHECK.ID NE 'HEADER' THEN
            VAR.ID<-1> = OUTWARD.ID
        END
        VAR.COUNT += 1
    REPEAT

    CHANGE @FM TO " " IN VAR.ID
    ENQ.DATA<2,-1> = "@ID"
    ENQ.DATA<3,-1> = "EQ"
    ENQ.DATA<4,-1> = VAR.ID

RETURN
END
