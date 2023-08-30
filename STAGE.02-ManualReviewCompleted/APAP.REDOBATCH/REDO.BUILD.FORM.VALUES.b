* @ValidationCode : MjotMjAwMzIwNDY4MDpDcDEyNTI6MTY4MTc5MzkyMDU3NDpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 10:28:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BUILD.FORM.VALUES(ENQ.DATA)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S Sudharsanan
* PROGRAM NAME: REDO.BUILD.FORM.VALUES
* ODR NO      : ODR-2009-10-0838
*-------------------------------------------------------------------------------------
*Modification
* Date                   who                   Reference              
* 18-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - VM TO @VM AND ++ TO += 1 
* 18-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------------
*----------------------------------------------------------------------
*DESCRIPTION: This is a Build Routine for a NOFILE Enquiry REDO.NOF.CRM.REPORT
*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.NOF.CRM.REPORT
*---------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------
    FORM.VALUE = '' ; Y.FLAG = '' ; Y.FINAL.ARR = '' ; VAR.ENQ.SEL.FLDS = ''
    VAR.ENQ.LOG.OPER = '' ; VAR.ENQ.SEL.VAL = ''
RETURN
*---------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------
    VAR.ENQ.SEL.FLDS = ENQ.DATA<2>
    VAR.ENQ.LOG.OPER = ENQ.DATA<3>
    VAR.ENQ.SEL.VAL = ENQ.DATA<4>
    Y.SEL.FLDS.CNT = DCOUNT(ENQ.DATA<2>,@VM)
    Y.SEL.VALUES.CNT = DCOUNT(ENQ.DATA<4>,@VM)
    IF Y.SEL.FLDS.CNT NE Y.SEL.VALUES.CNT THEN
        VAR.DIFF.CNT = Y.SEL.FLDS.CNT - Y.SEL.VALUES.CNT
        VAR.CNT = 1
        LOOP
        WHILE VAR.CNT LE VAR.DIFF.CNT
            FORM.VALUE<1,VAR.CNT> = @VM
            VAR.CNT += 1
        REPEAT
        VAR.ENQ.SEL.VAL = FORM.VALUE:VAR.ENQ.SEL.VAL
    END
    Y.CNT = 1
    Y.RUN = 1
    LOOP
    WHILE Y.CNT LE Y.SEL.FLDS.CNT
        IF VAR.ENQ.SEL.VAL<1,Y.CNT> NE '' THEN
            Y.FINAL.ARR<1,Y.RUN> = VAR.ENQ.SEL.FLDS<1,Y.CNT>
            Y.FINAL.ARR<2,Y.RUN> = VAR.ENQ.LOG.OPER<1,Y.CNT>
            Y.FINAL.ARR<3,Y.RUN> = VAR.ENQ.SEL.VAL<1,Y.CNT>
            Y.RUN += 1
            Y.FLAG = 1
        END
        Y.CNT += 1
    REPEAT

    IF Y.FLAG THEN
        ENQ.DATA<2> = Y.FINAL.ARR<1>
        ENQ.DATA<3> = Y.FINAL.ARR<2>
        ENQ.DATA<4> = Y.FINAL.ARR<3>
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
END
