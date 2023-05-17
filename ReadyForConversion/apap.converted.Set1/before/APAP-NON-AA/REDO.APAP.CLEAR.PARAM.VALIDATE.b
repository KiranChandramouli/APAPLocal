*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.APAP.CLEAR.PARAM.VALIDATE
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.APAP.CLEAR.PARAM.VALIDATE
*--------------------------------------------------------------------------------
* Description:
*--------------------------------------------------------------------------------
*            This validation routine to the REDO.APAP.CLEAR.PARAM tempalte
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 30-AUG-2011     KAVITHA       PACS00112979      Initial Creation
*----------------------------------------------------------------------------     

    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_F.FT.COMMISSION.TYPE
    $INCLUDE T24.BP I_F.FT.CHARGE.TYPE
    $INCLUDE TAM.BP I_F.REDO.APAP.CLEAR.PARAM



    FN.FT.COM.TYPE = 'F.FT.COMMISSION.TYPE'
    F.FT.COM.TYPE=''
    CALL OPF(FN.FT.COM.TYPE,F.FT.COM.TYPE)

    FN.FT.CHARGE.TYPE='F.FT.CHARGE.TYPE'
    F.FT.CHARGE.TYPE=''
    CALL OPF(FN.FT.CHARGE.TYPE,F.FT.CHARGE.TYPE)


    GET.FT.REF.CHG.LIST = R.NEW(CLEAR.PARAM.FT.REF.CHG)
    CHANGE VM TO FM IN GET.FT.REF.CHG.LIST
    TOT.VALUE = DCOUNT(GET.FT.REF.CHG.LIST,FM)

    R.FT.COM.TYPE = ''
    R.FT.CHARGE.TYPE = ''


    LOOP.CNTR = 1

    LOOP
    WHILE LOOP.CNTR LE TOT.VALUE

        GET.FT.REF.CHG = GET.FT.REF.CHG.LIST<LOOP.CNTR>
        CALL F.READ(FN.FT.COM.TYPE,GET.FT.REF.CHG,R.FT.COM.TYPE,F.FT.COM.TYPE,FCT.ERR)
        IF NOT(R.FT.COM.TYPE) THEN

            CALL F.READ(FN.FT.CHARGE.TYPE,GET.FT.REF.CHG,R.FT.CHARGE.TYPE,F.FT.CHARGE.TYPE,CHG.ERR)
            IF NOT(R.FT.CHARGE.TYPE) THEN
                AF = CLEAR.PARAM.FT.REF.CHG
                AV = LOOP.CNTR
                ETEXT = 'EB-INVALID.FT.CHG.CODE'
                CALL STORE.END.ERROR
            END
        END

        LOOP.CNTR += 1
    REPEAT

    RETURN
*------------------------ 
END

