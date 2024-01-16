* @ValidationCode : MjotNzY0NDQ3MDYwOkNwMTI1MjoxNzA0ODg4MzgwMzEwOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Jan 2024 17:36:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*18-05-2023    CONVERSION TOOL     R22 AUTO CONVERSION     FM TO @FM
*18-05-2023    VICTORIA S          R22 MANUAL CONVERSION   IF CONDITION MODIFIED
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.RELCUS.QTY.DEPS.ONE(CUST.ID,DEP.CNTR,TWENT.CNTR,FIFTY.CNTR,MORE.CNTR)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* Input/Output:
*--------------
* IN :CUSTOMER.ID
* OUT : DEP.CNTR
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
* Revision History:
*------------------------------------------------------------------------------------------
* Date who Reference Description
* 28-DEC-2009 B Renugadevi ODR-2010-04-0425 Initial Creation
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER.ACCOUNT
    $USING EB.LocalReferences

    GOSUB INIT
    GOSUB PROCESS
RETURN
*************
INIT:
*************
    CNT = ''
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''

    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

*    CALL GET.LOC.REF('ACCOUNT','L.AC.QTY.DEPOS',QTY.DEP.POS)
    EB.LocalReferences.GetLocRef('ACCOUNT','L.AC.QTY.DEPOS',QTY.DEP.POS);* R22 UTILITY AUTO CONVERSION
    DEP.CNTR = ''
RETURN
*********
PROCESS:
*********
    CUS.ID = CUST.ID
    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUS.ID,R.CUST,F.CUSTOMER.ACCOUNT,CUST.ERR)
    CNT = DCOUNT(R.CUST,@FM) ;*R22 AUTO CONVERSION
    INC = 1
    LOOP
    WHILE INC LE CNT
        ACC.ID = R.CUST<INC>
        CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        IF R.ACCOUNT THEN
            IF R.ACCOUNT<AC.LOCAL.REF><1,QTY.DEP.POS> EQ '0-10' THEN
                DEP.CNTR + = 1
            END
*IF R.ACC<AC.LOCAL.REF><1,QTY.DEP.POS> EQ '11-25' THEN
            IF R.ACCOUNT<AC.LOCAL.REF><1,QTY.DEP.POS> EQ '11-25' THEN ;*R22 MANUAL CONVERSION
                TWENT.CNTR + = 1
            END

            IF R.ACCOUNT<AC.LOCAL.REF><1,QTY.DEP.POS> EQ '26-50' THEN
                FIFTY.CNTR + = 1
            END
            IF R.ACCOUNT<AC.LOCAL.REF><1,QTY.DEP.POS> EQ '51- MORE' THEN
                MORE.CNTR + = 1
            END
        END
        INC +=1
    REPEAT
RETURN
END
