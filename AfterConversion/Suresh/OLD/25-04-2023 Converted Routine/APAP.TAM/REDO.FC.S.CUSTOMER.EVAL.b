* @ValidationCode : MjotMTQ2NDk5NjEzMjpDcDEyNTI6MTY4MjQyMDc4MTk0NzozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 16:36:21
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
SUBROUTINE REDO.FC.S.CUSTOMER.EVAL
*------------------------------------------------------------------------------------------------------------------
* Developer    : jvalarezoulloa@temenos.com
* Date         : 2012-04-17
* Description  : Evaluate if a Customer has a status Close
* Input/Output:
* -------------
* In  :
*
* Out :
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date               Name                      Description
* -------          ----               ----                      ------------
* MOdified by>
*
*                  18/09/2012         mgudino                   Add DECESED validation
*                  19/3/2012          Prakash                   Value in CUSTOMER's local field
*                                                               L.CU.TIPO.CL should not be 'CLIENTE MENOR'
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_EB.TRANS.COMMON
*
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.CREATE.ARRANGEMENT

    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB CLIENTE.MENOR.CUS.CHECK

RETURN
*------------------------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------------------------------
    Y.ID.CUSTOMER = COMI
    CALL F.READ(FN.CUSTOMER,Y.ID.CUSTOMER,R.CUSTOMER,F.CUSTOMER,ERR.MSJ)

    IF OFS$HOT.FIELD MATCHES 'CUSTOMER...' THEN
        GOSUB CUSTOMER.EVALUATE
    END
    ELSE
        IF COMI THEN
            Y.ID.CUSTOMER = R.NEW(REDO.FC.CUSTOMER)
            GOSUB CUSTOMER.EVALUATE
        END
    END

RETURN
*------------------------------------------------------------------------------------------------------------------
CUSTOMER.EVALUATE:
*------------------------------------------------------------------------------------------------------------------

    IF R.CUSTOMER THEN
        IF R.CUSTOMER<EB.CUS.CUSTOMER.STATUS> EQ 4 THEN
            AF = REDO.FC.CUSTOMER
            ETEXT = 'EB-FC-CUST-STATUS-CLOSE'
            CALL STORE.END.ERROR
        END
        IF R.CUSTOMER<EB.CUS.CUSTOMER.STATUS> EQ 3 THEN
            AF = REDO.FC.CUSTOMER
            ETEXT = 'EB-REDO.AC.DECESED'
            CALL STORE.END.ERROR
        END
    END ELSE
        AF = REDO.FC.CUSTOMER
        ETEXT = 'EB-FC-CUST-DONT-EXITS'
        CALL STORE.END.ERROR
    END

RETURN
*------------------------------------------------------------------------------------------------------------------
CLIENTE.MENOR.CUS.CHECK:
*------------------------------------------------------------------------------------------------------------------
* CLIENTE MENOR - RETAIL CUSTOMER not allowed - PACS00253689 - Start

    CU.TIPO.CL.VALUE = R.CUSTOMER<EB.CUS.LOCAL.REF,CU.TIPO.CL>
    IF CU.TIPO.CL.VALUE EQ 'CLIENTE MENOR' THEN
        AF = REDO.FC.CUSTOMER
        ETEXT = 'EB-CUS.TYPE.CLIENTE.MENOR'
        CALL STORE.END.ERROR
    END

* CLIENTE MENOR - RETAIL CUSTOMER not allowed - PACS00253689 - End
RETURN

*------------------------------------------------------------------------------------------------------------------
INITIALISE:
*------------------------------------------------------------------------------------------------------------------

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER  = ""
    R.CUSTOMER  = ""

*PACS00253689 - Start
    APPLICATION.ARRAY = "CUSTOMER"
    FLD.NAME = 'L.CU.TIPO.CL'
    Y.POS = ''

    CALL MULTI.GET.LOC.REF(APPLICATION.ARRAY,FLD.NAME,Y.POS)
    CU.TIPO.CL = Y.POS<1,1>
*PACS00253689 - End

RETURN
*------------------------------------------------------------------------------------------------------------------
OPENFILES:
*------------------------------------------------------------------------------------------------------------------
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)
RETURN
END
