* @ValidationCode : MjozODkzMzU2OTU6Q3AxMjUyOjE2ODExMzUxNjMzODQ6SVRTUzotMTotMTotMjc6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2023 19:29:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -27
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.SOLICITUD.AUTHORISE
*-----------------------------------------------------------------------------
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.FC.SOLICITUD

*** <region name= MAIN PROCESS LOGIC>
*** <desc>Main process logic</desc>
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*** </region>


*** <region name= PROCESS>
*** <desc>Process</desc>
PROCESS:
    IF R.OLD(FC.SL.ESTATUS) NE R.NEW(FC.SL.ESTATUS) THEN
        BEGIN CASE
            CASE R.NEW(FC.SL.ESTATUS) EQ "REFERIDA"
                R.NEW(FC.SL.FEC.SOLICITA) = TODAY
            CASE R.NEW(FC.SL.ESTATUS) EQ "PREAPROBADA"
                R.NEW(FC.SL.FEC.PREAPROB) = TODAY
            CASE R.NEW(FC.SL.ESTATUS) EQ "FORMALIZADA"
                R.NEW(FC.SL.FEC.FRMNEG) = TODAY
            CASE R.NEW(FC.SL.ESTATUS) EQ "APROBADA"
                R.NEW(FC.SL.FEC.APROBADO) = TODAY
        END CASE
    END

    GOSUB CONCAT.FILE.LISTENER
RETURN
*** </region>

*** <region name= INITIALISE>
*** <desc>Initialise</desc>
INITIALISE:
* Concat file
    FN.REDO.FC.CUST.SOLICITUD = 'F.REDO.FC.CUST.SOLICITUD'
* ID Cliente
    Y.CUST.ID = R.NEW(FC.SL.CUSTOMER)
    Y.SOL.ID = ID.NEW

RETURN
*** </region>

*** <region name= CONCAT.FILE.LISTENER>
*** <desc>Concat File Listener</desc>
CONCAT.FILE.LISTENER:
    CALL CONCAT.FILE.UPDATE(FN.REDO.FC.CUST.SOLICITUD,Y.CUST.ID,Y.SOL.ID,'I','AR')
RETURN
*** </region>

END
