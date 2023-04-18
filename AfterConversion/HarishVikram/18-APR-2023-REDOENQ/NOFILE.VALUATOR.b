* @ValidationCode : Mjo4OTU4NzkxOTI6Q3AxMjUyOjE2ODE4MDEyNjMxMDg6SGFyaXNodmlrcmFtQzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 12:31:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE NOFILE.VALUATOR(AC.DETAILS)
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : NOFILE.VALUATOR
* Attached as     : ROUTINE
* Primary Purpose : GET THE INFORMATION FROM APLICATION EVALUATORS
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*------------------------------------------------------------------------------

* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Pablo Castillo De La Rosa - TAM Latin America
* Date            : 03-OCT-2011
*
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 18-APR-2023      Conversion tool    R22 Auto conversion       No changes
* 18-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.VALUATOR.NAME
    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END


RETURN  ;* Program RETURN
*------------------------------------------------------------------------------

PROCESS:
*======
*

    CALL OPF(FN.REDO.VALUATOR.NAME,F.CUA.PC)

* Read the lis of valuators
    SELECT.STATEMENT = 'SELECT ':FN.REDO.VALUATOR.NAME
    LOCK.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    Y.ID.AA.PRD = ''
    CALL EB.READLIST(SELECT.STATEMENT,LOCK.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

*Get the data that view in the list
    LOOP
        REMOVE Y.ID.AA.PRD FROM LOCK.LIST SETTING POS
    WHILE Y.ID.AA.PRD:POS


        CALL F.READ (F.REDO.VALUATOR.NAME,Y.ID.AA.PRD,R.CUA,F.CUA.PC,Y.CUA.ERR)

        AC.DETAILS<-1>=Y.ID.AA.PRD:"*":R.CUA<2>:" ":R.CUA<1>

    REPEAT

RETURN
*------------------------------------------------------------------------

INITIALISE:
*=========
*
    PROCESS.GOAHEAD = 1

*Inicialice Vars for open
    F.CUA.PC  = ''
    R.CUA = ''
    Y.CUA.ERR = ''

RETURN

*------------------------
OPEN.FILES:
*=========

*OPEN THE FILE VALUATOR NAME
    FN.REDO.VALUATOR.NAME = 'F.REDO.VALUATOR.NAME'
    F.REDO.VALUATOR.NAME = ''

    CALL OPF(FN.REDO.VALUATOR.NAME,F.REDO.VALUATOR.NAME)

RETURN
*------------
END
