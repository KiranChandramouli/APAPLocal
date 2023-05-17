SUBROUTINE REDO.E.BLD.REL.CU(ENQ.DATA)

*----------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : RAJA SAKTHIVEL K P
* Program Name : REDO.E.BLD.REL.CU
*----------------------------------------------------------
* Description : This subroutine is attached as a build routine in the Enquiry REPO.CU.VINCULADOS
* to populate the label rel.code as per the relatione code range

* Linked with : Enquiry REPO.CU.VINCULADOS as build routine
* In Parameter : ENQ.DATA
* Out Parameter : ENQ.DATA
*-----------------------------------------------------------
* Modification made for the issue PACS00036104 to change the range from 300 to 499
* By Marimuthu S

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN


PROCESS:


    CUS.ID = ENQ.DATA<4,1>

    IF NOT(CUS.ID) THEN
        OPERAND.VALUE = "EQ"
        SEL.CMD = "SELECT ":FN.CUSTOMER:" WITH RELATION.CODE GE 300"
        CALL EB.READLIST(SEL.CMD,CUS.ID.LIST,'',NO.CUS.ID,'')
        LOOP
            REMOVE CUS.ID FROM CUS.ID.LIST SETTING STMT.POS
        WHILE CUS.ID : STMT.POS
            IF CUS.ID THEN
                GOSUB CHECK.DATA
            END
        REPEAT
    END ELSE
        OPERAND.VALUE=ENQ.DATA<3,1>
        GOSUB CHECK.DATA
    END

RETURN
*-------------------------------------------------------
* Here, the value of the relation code is checked
*-------------------------------------------------------
CHECK.DATA:

    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,ERR.CUSTOMER)
    IF R.CUSTOMER THEN
        Y.REL.CODE = R.CUSTOMER<EB.CUS.RELATION.CODE>
        Y.REL.CNT = DCOUNT(Y.REL.CODE,@VM) + 1
        START.LOOP = 1
        VALID.CUSTOMER = 1
        LOOP
        WHILE START.LOOP LT Y.REL.CNT
            GOSUB CHECK.CODE
        REPEAT
    END

RETURN
*----------------------------------------------------------------------------
* Here, the customer record which satisfies the condition are filtered out
*----------------------------------------------------------------------------
CHECK.CODE:
    REL.CODE = Y.REL.CODE<1,START.LOOP>
    IF REL.CODE GE 300 AND REL.CODE LE 499 THEN
        IF VALID.CUSTOMER THEN
            ENQ.DATA<2,-1> = '@ID'
            ENQ.DATA<3,-1> = OPERAND.VALUE
            ENQ.DATA<4,-1> = CUS.ID
            VALID.CUSTOMER = 0
        END
    END
    START.LOOP += 1
RETURN
*------------------------------------------------------------------------------
END
