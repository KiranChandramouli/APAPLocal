* @ValidationCode : Mjo2MzcwODY2MDc6Q3AxMjUyOjE2ODE4OTAyNTA2MjI6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Apr 2023 13:14:10
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
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*19/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          = TO EQ, I TO I.WAR
*19/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
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

    FOR I.VAR = 1 TO CNT  ;*AUTO R22 CODE CONVERSION
        C.TYPE = R.CCP<CERT.CHEQ.TYPE,I.VAR>
        IF C.TYPE EQ 'NON.GOVT' THEN ;*AUTO R22 CODE CONVERSION
            IF AC.ID.LIST THEN
                AC.ID.LIST := " ": R.CCP<CERT.CHEQ.ACCOUNT.NO,I.VAR> ;*AUTO R22 CODE CONVERSION
            END ELSE
                AC.ID.LIST = R.CCP<CERT.CHEQ.ACCOUNT.NO,I.VAR> ;*AUTO R22 CODE CONVERSION
            END
        END
    NEXT I.VAR ;*AUTO R22 CODE CONVERSION


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
