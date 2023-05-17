SUBROUTINE REDO.V.VAL.FR.COMP.DESC.CLAIM
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : A validation routine is written to update the DESCRIPTION.CLIAM field from
*the local table REDO.SLA.PARAM
*
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.VAL.ISSUE.COMP.DESC.CLAIM
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* *01-MAR-2010     PRABHU             HD1100464         INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.FRONT.COMPLAINTS
    $INSERT I_F.REDO.SLA.PARAM

    GOSUB INIT
    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------------------------
    FN.REDO.SLA.PARAM = 'F.REDO.SLA.PARAM'
    F.REDO.SLA.PARAM = ''
    CALL OPF(FN.REDO.SLA.PARAM,F.REDO.SLA.PARAM)
RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------------------
    IF AF EQ FR.CM.PRODUCT.TYPE THEN
        IF (VAL.TEXT) AND COMI NE 'OTROS' AND R.NEW(FR.CM.ACCOUNT.ID) EQ '' THEN
            ETEXT="EB-ACCT.NO.MAND"
            CALL STORE.END.ERROR
        END
        Y.PRDT.TYPE = COMI
*        VAR.PRDT.TYPE = FIELD(Y.PRDT.TYPE,"-",2)
        Y.TYPE = R.NEW(FR.CM.TYPE)
*        VAR.TYPE = FIELD(Y.TYPE,"-",2)
        Y.ID = Y.TYPE:'-':Y.PRDT.TYPE
        IF Y.TYPE NE '' THEN
            GOSUB DES.CLAIM
        END
    END
    IF AF EQ FR.CM.TYPE THEN
        Y.PRDT.TYPE = R.NEW(FR.CM.PRODUCT.TYPE)
        VAR.PRDT.TYPE = FIELD(Y.PRDT.TYPE,"-",2)
        Y.TYPE = COMI
        VAR.TYPE = FIELD(Y.TYPE,"-",2)
        IF Y.TYPE EQ 'INTERACCION' THEN
            Y.ID = Y.TYPE:'-':Y.PRDT.TYPE
            IF Y.PRDT.TYPE NE '' THEN
                GOSUB DES.CLAIM
            END
        END ELSE
            AF = FR.CM.TYPE
            ETEXT ='EB-NOT.VALID.TYPE'
            CALL STORE.END.ERROR
        END
    END
RETURN
*-------------------------------------------------------------------------------------------
DES.CLAIM:
*-------------------------------------------------------------------------------------------
    CALL F.READ(FN.REDO.SLA.PARAM,Y.ID,R.SLA.PARAM,F.REDO.SLA.PARAM,PARA.ERR)
    IF R.SLA.PARAM THEN
        R.NEW(FR.CM.SLA.ID) = Y.ID
    END ELSE
        AF = FR.CM.PRODUCT.TYPE
        ETEXT ='EB-NOT.VALID.PRODUCT':@FM:Y.PRDT.TYPE:@VM:Y.TYPE
        CALL STORE.END.ERROR
    END
RETURN
*----------------------------------------------------------------------------------------------
END
