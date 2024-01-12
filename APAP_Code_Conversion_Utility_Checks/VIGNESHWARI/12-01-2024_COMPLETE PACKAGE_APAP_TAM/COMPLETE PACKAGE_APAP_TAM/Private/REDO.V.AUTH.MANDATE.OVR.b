* @ValidationCode : MjotMTgwOTY4MTA4MjpVVEYtODoxNzA0OTc2MDk2NzYwOkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Jan 2024 17:58:16
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.V.AUTH.MANDATE.OVR
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.AUTH.MANDATE.OVR
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is attached as authorization routine in all the version used
*                  in the development N.83.It will fetch the value from sunnel interface
*                  and assigns it in R.NEW
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 16-APR-2010        Prabhu.N       ODR-2009-10-0536    Initial Creation
* 03-DEC-2010        Prabhu.N       ODR-2010-11-0211    Modified based on Sunnel
* 12-JAN-2011        Kavitha.S      ODR-2010-11-0211    Added logic based on B.126 TFS
*26 JUN 2011         Prabhu N       PACS00061657        Added teller logic with credit and debit marker
*13/07/2023	     CONVERSION TOOL                        AUTO R22 CODE CONVERSION- VM TO @VM,FM TO @FM,++ TO += 1,REM TO DISPLAY.MESSAGE(TEXT, '')
*13/07/2023	      VIGNESHWARI        	                MANUAL R22 CODE CONVERSION-CALL ROUTINE IS MODIFIED
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_F.REDO.APAP.STO.DUPLICATE
    $INSERT I_F.CUSTOMER
    $INSERT I_System
    $USING EB.OverrideProcessing

    $USING APAP.REDOEB

    FN.CUSTOMER = 'F.CUSTOMER'
    F.ACCOUNT = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.APAP.STO.DUPLICATE.NAU = 'F.REDO.APAP.STO.DUPLICATE$NAU'
    F.REDO.APAP.STO.DUPLICATE.NAU = ''
    CALL OPF(FN.REDO.APAP.STO.DUPLICATE.NAU,F.REDO.APAP.STO.DUPLICATE.NAU)




    CUST.ID= System.getVariable("EXT.SMS.CUSTOMERS")

    CALL F.READ(FN.CUSTOMER,CUST.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)

    Y.MANDATE.APPL   = R.CUSTOMER<EB.CUS.MANDATE.APPL>
    Y.MANDATE.RECORD = R.CUSTOMER<EB.CUS.MANDATE.RECORD>
    CHANGE @VM TO @FM IN Y.MANDATE.APPL
    CHANGE @VM TO @FM IN Y.MANDATE.RECORD
    Y.MANDATE.TOT = DCOUNT(Y.MANDATE.APPL,@FM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.MANDATE.TOT
        IF EB.EXTERNAL$USER.ID THEN
            Y.MAND.APPL.ID   = Y.MANDATE.APPL<Y.CNT>
            Y.MAND.GROUP.ID  = Y.MANDATE.RECORD<Y.CNT>
            IF Y.MAND.APPL.ID EQ 'STANDING.ORDER' THEN
                Y.MAND.ST.DATE  = FIELD(FIELD(Y.MAND.GROUP.ID,'.',2),'-',1)
                IF Y.MAND.ST.DATE GE TODAY THEN
                    ALLOW.APPROVAL = ''
                    APAP.REDOEB.redoEbCheckMandate(ALLOW.APPROVAL,Y.MAND.GROUP.ID);*MANUAL R22 CODE CONVERSION
                    GOSUB RAISE.OVERRIDE
                END
            END
        END
        Y.CNT += 1
    REPEAT
RETURN
***************
RAISE.OVERRIDE:
***************
    IF ALLOW.APPROVAL THEN
        DISPLAY.REM = 'Minimum Signatory has not reached'
    END ELSE
        RETURN
    END

    IF DISPLAY.REM THEN
        R.NEW(REDO.SO.MANDATE.STATUS) = 'YES'
        TEXT = DISPLAY.REM
*        CALL DISPLAY.MESSAGE(TEXT, '');*AUTO R22 CODE CONVERSION
        EB.OverrideProcessing.DisplayMessage(TEXT, '');*AUTO R22 CODE CONVERSION;* R22 UTILITY AUTO CONVERSION
    END

RETURN

END
