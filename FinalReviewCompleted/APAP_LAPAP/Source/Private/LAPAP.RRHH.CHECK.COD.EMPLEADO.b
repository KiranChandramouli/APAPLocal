* @ValidationCode : Mjo5OTc0NTE5NTA6Q3AxMjUyOjE2ODQyMjI4MTQ1ODM6SVRTUzotMTotMTozODc6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 387
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.RRHH.CHECK.COD.EMPLEADO(ENQ.DATA)
*-------------------------------------------------------------------------
* Developed By  : OLIVER FERMIN
* Date  : 16/12/2019
* Valida si el CUSTOMER.ID posee el codigo de empleado en el campo FAX.1
*-------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*21-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*21-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*---------------------------------------------------------------------------------------------------

    $INSERT I_COMMON      ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_ENQUIRY.COMMON     ;*R22 AUTO CODE CONVERSION.END

    GOSUB OPENFILES
    GOSUB PROCESS

RETURN

*---------
OPENFILES:
*---------

    FN.AA = "F.AA.ARRANGEMENT"
    F.AA = ""
    CALL OPF(FN.AA,F.AA)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN


PROCESS:
*******

    LOCATE 'ARRANGEMENT.ID' IN ENQ.DATA SETTING CUS.POS THEN
        Y.AA.ID =  ENQ.DATA<4>
    END

    R.AA = '' ; ERROR.AA = '' ;
    CALL F.READ(FN.AA,Y.AA.ID, R.AA, F.AA, ERROR.AA)
    Y.AA.CUSTOMER.ID = R.AA<AA.ARR.CUSTOMER>

    CALL F.READ(FN.CUSTOMER, Y.AA.CUSTOMER.ID, R.CUSTOMER, F.CUSTOMER,ERR)
    Y.CODIGO.EMPLEADO = R.CUSTOMER<EB.CUS.FAX.1>

    IF Y.CODIGO.EMPLEADO EQ '' THEN
        ENQ.ERROR = 'EB-NO.ACCESS.EX.EMPLEADO'
        CALL STORE.END.ERROR
    END

RETURN

END
