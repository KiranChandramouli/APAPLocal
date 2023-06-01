* @ValidationCode : Mjo0MTUxODA3NzM6Q3AxMjUyOjE2ODI0MTIzMzA4MjQ6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.CHK.EXIST.CATEG
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SHANKAR RAJU
*Program   Name    :REDO.INP.CHK.EXIST.CATEG
*Reference Number  :HD1048505
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to check if the category has been assigned to any TELLER

*LINKED WITH       :
* ----------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*06-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*06-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*----------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.ID
    $INSERT I_F.TOLERANCE.CATEG.RANGE

    GOSUB INIT
    GOSUB PROCESS

RETURN
*----------------------------------------------------------------------------------
INIT:
*~~~~

    FN.TELLER.ID = 'F.TELLER.ID'
    F.TELLER.ID = ''
    CALL OPF(FN.TELLER.ID,F.TELLER.ID)

RETURN
*----------------------------------------------------------------------------------
PROCESS:
*~~~~~~~

    IF V$FUNCTION EQ 'R' THEN

        SEL.CMD = "SELECT ":FN.TELLER.ID:" WITH L.TT.TOL.CAT.RG EQ ":COMI
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR)

        IF SEL.LIST THEN
            E = 'EB-CATEG.ALRDY.ASSIGN'
        END

    END
RETURN
*----------------------------------------------------------------------------------
END
