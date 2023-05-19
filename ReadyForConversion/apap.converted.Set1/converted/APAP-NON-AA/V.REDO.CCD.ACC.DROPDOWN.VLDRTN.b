SUBROUTINE V.REDO.CCD.ACC.DROPDOWN.VLDRTN(ENQ.OUT)


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CERTIFIED.CHEQUE.DETAILS
    $INSERT I_F.CERTIFIED.CHEQUE.PARAMETER


*----------
OPEN.FILES:
*----------

    FN.CERTIFIED.CHEQUE.PARAMETER = 'F.CERTIFIED.CHEQUE.PARAMETER'
    F.CERTIFIED.CHEQUE.PARAMETER = ''
    CALL OPF(FN.CERTIFIED.CHEQUE.PARAMETER, F.CERTIFIED.CHEQUE.PARAMETER)

    CCP.ID = ''
    R.CCP  = ''
    C.TYPE = ''
    AC.ID.LIST = ''

*-------
PROCESS:
*-------

    CCP.ID = ID.COMPANY
* CALL F.READ(FN.CERTIFIED.CHEQUE.PARAMETER, CCP.ID, R.CCP, F.CERTIFIED.CHEQUE.PARAMETER, CCP.ERR) ;*Tus Start
    CALL CACHE.READ(FN.CERTIFIED.CHEQUE.PARAMETER, CCP.ID, R.CCP, CCP.ERR) ;*Tus End
    CNT = DCOUNT(R.CCP<CERT.CHEQ.TYPE>,@VM)

    FOR I.VAR = 1 TO CNT
        C.TYPE = R.CCP<CERT.CHEQ.TYPE,I.VAR>
        IF C.TYPE EQ 'NON.GOVT' THEN
            IF AC.ID.LIST THEN
                AC.ID.LIST := " ": R.CCP<CERT.CHEQ.ACCOUNT.NO,I.VAR>
            END ELSE
                AC.ID.LIST = R.CCP<CERT.CHEQ.ACCOUNT.NO,I.VAR>
            END
        END
    NEXT I.VAR


    IF AC.ID.LIST THEN
        AC.ID.LIST := " ": R.CCP<CERT.CHEQ.YEAR.ACCOUNT>
    END ELSE
        AC.ID.LIST = R.CCP<CERT.CHEQ.YEAR.ACCOUNT>
    END


*-----
FINAL:
*-----

    ENQ.OUT<2,1> = "@ID"
    ENQ.OUT<3,2> = "EQ"
    ENQ.OUT<4,1> = AC.ID.LIST


RETURN

END