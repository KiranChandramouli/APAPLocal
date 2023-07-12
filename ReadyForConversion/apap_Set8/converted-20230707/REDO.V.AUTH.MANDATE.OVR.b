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
                    CALL REDO.EB.CHECK.MANDATE(ALLOW.APPROVAL,Y.MAND.GROUP.ID)
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
        CALL DISPLAY.MESSAGE(TEXT, '')
    END

RETURN

END
