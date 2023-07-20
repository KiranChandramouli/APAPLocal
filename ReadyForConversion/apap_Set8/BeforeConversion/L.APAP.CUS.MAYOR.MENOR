*-----------------------------------------------------------------------------
* <Rating>140</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.CUS.MAYOR.MENOR(CUSTOMER.ID)

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.CUSTOMER
    $INSERT LAPAP.BP I_L.APAP.CUS.MAYOR.MENOR.COMMON


    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERROR)

    FECHA.NACIMIENTO.CLI =  R.CUSTOMER<EB.CUS.DATE.OF.BIRTH>

    CALL GET.LOC.REF('CUSTOMER','L.CU.TIPO.CL',L.CU.TIPO.CL.POS)

    TIPO.CLI = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>

    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERROR)


    IF TIPO.CLI EQ 'CLIENTE MENOR' THEN

        Y.YEAR.DIFF = TODAY[1,4] - FECHA.NACIMIENTO.CLI [1,4]
        Y.MONTH.DIFF = TODAY[5,2] - FECHA.NACIMIENTO.CLI [5,2]
        Y.DATE.DIFF = TODAY[7,2] - FECHA.NACIMIENTO.CLI [7,2]

        IF Y.YEAR.DIFF >= 18 THEN

            IF Y.YEAR.DIFF = 18 THEN

                IF Y.MONTH.DIFF > 0 THEN

                    GOSUB UPDATECUST

                    RETURN

                END

                IF Y.MONTH.DIFF = 0 THEN

                    IF  Y.DATE.DIFF >= 0 THEN

                          GOSUB UPDATECUST 

                      RETURN

                    END

                END

                RETURN
                
            END

            GOSUB UPDATECUST

            RETURN

        END 

    END     

RETURN

UPDATECUST:  

        Y.TRANS.ID = ""
        Y.APP.NAME = "CUSTOMER"
        Y.VER.NAME = Y.APP.NAME :",MB.DM.LOAD"
        Y.FUNC = "I"
        Y.PRO.VAL = "PROCESS"
        Y.GTS.CONTROL = ""
        Y.NO.OF.AUTH = ""
        FINAL.OFS = ""
        OPTIONS = ""
        R.CUSTOMER = ""

        R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> = 'PERSONA FISICA'

        CALL OCOMO('CLIENTE MODIFICADO ' :  CUSTOMER.ID)

        CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,CUSTOMER.ID,R.CUSTOMER,FINAL.OFS)
        CALL OFS.POST.MESSAGE(FINAL.OFS,'',"DM.OFS.SRC.VAL",'')

        RETURN

END
