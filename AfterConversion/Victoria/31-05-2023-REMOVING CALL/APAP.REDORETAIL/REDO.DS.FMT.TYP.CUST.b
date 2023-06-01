* @ValidationCode : Mjo4NTgyMzYwMTg6Q3AxMjUyOjE2ODE4MjkwOTUyNDI6SVRTUzotMTotMToxODY6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 20:14:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 186
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.FMT.TYP.CUST(CUST.ID,CUS.TYPE)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is field format routine for the pdf generation form of KYC REDO.DS.FMT.TYP.CUST
* This development is for ODR Reference ODR-2010-04-0425
* Input/Output:
*--------------
* IN : ACCOUNT.ID
* OUT : CUSTOMER.TYPE
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------------------------------------------------------------------------------
* Date who Reference Description
* 25-Nov-2009 B Renugadevi ODR-2010-04-0425 Initial creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    GOSUB INIT
    GOSUB PROCESS
RETURN
******
INIT:
******
    CUS.ID = CUST.ID
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL GET.LOC.REF('CUSTOMER','L.CU.CIDENT',CIDENT.POS)
RETURN

********
PROCESS:
********
    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    IF R.CUSTOMER THEN
        IF R.CUSTOMER<EB.CUS.LOCAL.REF><1,CIDENT.POS> NE '' THEN
            CUS.TYPE = 'CEDULA'
        END ELSE
            IF R.CUSTOMER<EB.CUS.LEGAL.ID> NE '' THEN
                CUS.TYPE = 'PASAPORTE'
            END ELSE
                CUS.TYPE = ''
            END
        END
    END
RETURN
END
