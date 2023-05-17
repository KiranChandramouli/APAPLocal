SUBROUTINE REDO.S.UPD.CUS.ACTANAC.LOAD

* Correction routine to update the file F.CUSTOMER.L.CU.ACTANAC
* It is one time service routine. It's not required for another migration environment.

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_REDO.S.UPD.CUS.ACTANAC.COMMON

    GOSUB INIT

RETURN

******
INIT:
******
*Initialise all the variable

    FN.CUS = 'F.CUSTOMER'
    F.CUS = ''
    CALL OPF(FN.CUS,F.CUS)

    FN.CUS.ACTANAC = 'F.CUSTOMER.L.CU.ACTANAC'
    F.CUS.ACTANAC = ''
    CALL OPF(FN.CUS.ACTANAC,F.CUS.ACTANAC)

    LRF.APP = 'CUSTOMER'
    LRF.FIELD = 'L.CU.ACTANAC'
    ACT.LRF.POS = ''
    CALL GET.LOC.REF(LRF.APP,LRF.FIELD,ACT.LRF.POS)

RETURN

END
