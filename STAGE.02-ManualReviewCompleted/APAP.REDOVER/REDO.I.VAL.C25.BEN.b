* @ValidationCode : MjoyMTU2MjQ5NjI6Q3AxMjUyOjE2ODA3NzgzOTgxNjA6bXV0aHU6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 16:23:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : muthu
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.I.VAL.C25.BEN
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.I.VAL.C25.BEN
*--------------------------------------------------------------------------------------------------------
*Description  : This is a Input routine to check any one of benificiary field has value in the versions
* used for SAP webservices.
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 19 Aug 2012     Balagurunathan          PACS00211209           Initial Creation
* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 NO CHANGE
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE
*--------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER


    Y.APP=APPLICATION
    Y.FLD='BENEFIC.NAME'
    Y.POS=''
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD,Y.POS)

    FLD.POS= Y.POS<1,1>

    FLD.VAL=R.NEW(FT.LOCAL.REF)<1,FLD.POS,1>
    FLD.VAL1=R.NEW(FT.LOCAL.REF)<1,FLD.POS,2>

    IF FLD.VAL EQ '' AND FLD.VAL1 EQ '' THEN
        AF=FT.LOCAL.REF
        AV=FLD.VAL
        AS=1
        ETEXT='EB-REDO.BEN.INP.MISS'
        CALL STORE.END.ERROR

    END


RETURN

END
